using UnityEngine;
using UnityEngine.UI;
using TMPro;
using System.Collections;
using System.Collections.Generic;

public class WordGameControllerUI : MonoBehaviour
{
    [System.Serializable]
    public class WordDefinition
    {
        public string id;
        public Sprite promptSprite;              // missing-letter image
        public Sprite fullWordSprite;            // full word image (shown on correct)
        public Sprite[] options = new Sprite[3]; // three letter sprites
        [Range(0, 2)] public int correctIndex;   // index into options BEFORE shuffle
    }

    [Header("Round Config")]
    public List<WordDefinition> allWords = new List<WordDefinition>();
    public int  roundLength          = 10;
    public float wrongRetryPause     = 0.35f;   // delay before letting them retry after a wrong tap
    public float fullWordRevealTime  = 1.2f;    // how long to keep full word visible on correct

    [Header("UI References")]
    public Image               promptImage;      // incomplete word
    public Image               fullWordImage;    // complete word (only on correct)
    public OptionButtonUI[]    optionButtons;    // exactly 3 buttons
    public TextMeshProUGUI     scoreText;
    public TextMeshProUGUI     progressText;

    [Header("FX / Audio")]
    public ParticleSystem      confettiPrefab;
    public Transform           confettiSpawnPoint;
    public float               confettiLifetime = 1.2f;
    public AudioSource         sfxSource;
    public AudioClip           correctSfx;
    public AudioClip           wrongSfx;

    // Runtime
    private List<WordDefinition> roundWords;
    private int   currIndex  = -1;
    private int   score      = 0;
    private bool  inputLocked = false;

    private WordDefinition currentWord;
    private ParticleSystem activeConfetti;

    // Scoring gates
    private bool disqualifyScoreThisWord = false;   // any wrong attempt on this word -> no point for this word
    private bool awardedThisWord         = false;   // guard against double-award (shouldn’t happen, but safe)

    void Start() => StartRound();

    public void StartRound()
    {
        score = 0;
        roundWords = new List<WordDefinition>(allWords);
        Shuffle(roundWords);
        if (roundWords.Count > roundLength)
            roundWords = roundWords.GetRange(0, roundLength);

        currIndex = -1;
        UpdateHUD(0, roundWords.Count);
        NextWord();
    }

    void UpdateHUD(int solved, int total)
    {
        if (scoreText)    scoreText.text = $"Score: {score}";
        if (progressText) progressText.text = $"{solved}/{total}";
    }

    void NextWord()
    {
        currIndex++;
        if (currIndex >= roundWords.Count)
        {
            ShowEndScreen();
            return;
        }

        inputLocked = false;
        disqualifyScoreThisWord = false;
        awardedThisWord = false;

        // Reset UI
        if (promptImage)   { promptImage.gameObject.SetActive(true);  promptImage.enabled = true; }
        if (fullWordImage) { fullWordImage.gameObject.SetActive(false); }

        currentWord = roundWords[currIndex];
        if (promptImage) promptImage.sprite = currentWord.promptSprite;

        // Randomize display order of options
        var order = new List<int> { 0, 1, 2 };
        Shuffle(order);

        for (int i = 0; i < optionButtons.Length; i++)
        {
            int srcIdx = order[i];
            bool isCorrect = (srcIdx == currentWord.correctIndex);
            optionButtons[i].gameObject.SetActive(true);
            optionButtons[i].Bind(this, currentWord.options[srcIdx], isCorrect);
            optionButtons[i].ResetVisual();
        }

        UpdateHUD(currIndex, roundWords.Count);
    }

    public void SubmitAnswer(OptionButtonUI btn)
    {
        if (inputLocked || btn == null) return;
        inputLocked = true;

        bool isCorrect = btn.IsCorrect;

        if (isCorrect)
        {
            // Award only if first try (no prior wrong on this word) and not already awarded.
            if (!disqualifyScoreThisWord && !awardedThisWord)
            {
                score++;
                awardedThisWord = true;
                if (scoreText) scoreText.text = $"Score: {score}";
            }

            if (sfxSource && correctSfx) sfxSource.PlayOneShot(correctSfx);

            // Lock visuals: highlight correct, disable others
            foreach (var b in optionButtons)
            {
                if (!b) continue;
                if (b == btn) b.SetCorrect();
                else          b.SetDisabled();
            }

            StartCoroutine(HandleCorrectThenAdvance());
        }
        else
        {
            // Any wrong attempt disqualifies this word from scoring
            disqualifyScoreThisWord = true;

            if (sfxSource && wrongSfx) sfxSource.PlayOneShot(wrongSfx);

            // Mark this option as wrong and hide/disable it so they must choose another
            btn.SetWrong();
            btn.gameObject.SetActive(false);

            // Stay on the same word; re-enable input after a short pause
            StartCoroutine(UnlockAfterWrong());
        }
    }

    IEnumerator HandleCorrectThenAdvance()
    {
        // Show full word (and hide prompt) on correct
        if (promptImage)
        {
            promptImage.enabled = false;
            promptImage.gameObject.SetActive(false);
        }
        if (fullWordImage && currentWord != null && currentWord.fullWordSprite)
        {
            fullWordImage.sprite = currentWord.fullWordSprite;
            fullWordImage.gameObject.SetActive(true);
        }

        // Confetti
        if (confettiPrefab && confettiSpawnPoint)
        {
            activeConfetti = Instantiate(confettiPrefab, confettiSpawnPoint.position, confettiSpawnPoint.rotation);
            activeConfetti.Play();
        }

        float wait = activeConfetti ? Mathf.Max(fullWordRevealTime, confettiLifetime) : fullWordRevealTime;
        yield return new WaitForSeconds(wait);

        if (activeConfetti) { Destroy(activeConfetti.gameObject); activeConfetti = null; }

        foreach (var b in optionButtons) if (b) b.ResetVisual();
        NextWord();
    }

    IEnumerator UnlockAfterWrong()
    {
        yield return new WaitForSeconds(wrongRetryPause);
        inputLocked = false; // still on same word; student must pick again
    }

    void HideGameplayUI()
    {
        if (promptImage)   promptImage.gameObject.SetActive(false);
        if (fullWordImage) fullWordImage.gameObject.SetActive(false);

        if (optionButtons != null)
            foreach (var b in optionButtons)
                if (b) b.gameObject.SetActive(false);

        if (scoreText)    scoreText.gameObject.SetActive(false);
        if (progressText) progressText.gameObject.SetActive(false);
    }

    void ShowEndScreen()
    {
        if (activeConfetti) { Destroy(activeConfetti.gameObject); activeConfetti = null; }
        HideGameplayUI();

        var panel = FindObjectOfType<WordRoundEndPanelUI>(true);
        if (panel) panel.Show(score, roundWords.Count);
    }

    static void Shuffle<T>(IList<T> list)
    {
        for (int i = list.Count - 1; i > 0; i--)
        {
            int j = Random.Range(0, i + 1);
            (list[i], list[j]) = (list[j], list[i]);
        }
    }
}
