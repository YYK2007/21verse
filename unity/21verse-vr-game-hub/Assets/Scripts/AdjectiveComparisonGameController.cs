using UnityEngine;
using UnityEngine.UI;
using TMPro;
using System.Collections;
using System.Collections.Generic;

public class AdjectiveComparisonGameController : MonoBehaviour
{
    [System.Serializable]
    public class AdjectiveQuestion
    {
        public string id;
        public Sprite questionSprite;           // question image (e.g., "Which is bigger?")
        public AudioClip questionAudio;         // [NEW] The spoken version of the question
        public Sprite option1Sprite;            // first option image
        public Sprite option2Sprite;            // second option image
        [Range(0, 1)] public int correctIndex;  // 0 for option1, 1 for option2
    }

    [Header("Round Config")]
    public List<AdjectiveQuestion> allQuestions = new List<AdjectiveQuestion>();
    public int roundLength = 10;
    public float afterAnswerDelay = 0.8f;
    public float answerRevealTime = 1.2f;
    public float audioRepeatInterval = 15f;     // [NEW] How often to repeat the audio

    [Header("UI References")]
    public Image questionImage;
    public AdjectiveOptionButton[] optionButtons; // 2 buttons
    public TextMeshProUGUI scoreText;
    public TextMeshProUGUI progressText;

    [Header("FX / Audio")]
    public ParticleSystem confettiPrefab;
    public Transform confettiSpawnPoint;
    public float confettiLifetime = 1.2f;
    public AudioSource questionAudioSource;     // [NEW] Source for the question voiceover
    public AudioSource sfxSource;               // Source for correct/wrong blips
    public AudioClip correctSfx;
    public AudioClip wrongSfx;

    // Runtime
    private List<AdjectiveQuestion> roundQuestions;
    private int currIndex = -1;
    private int score = 0;
    private bool inputLocked = false;
    private ParticleSystem activeConfetti;
    private Coroutine audioRepeatCoroutine;     // [NEW] Track the repeat loop to stop it later

    void Start() => StartRound();

    public void StartRound()
    {
        score = 0;

        // Build the round (shuffle and clip to roundLength)
        roundQuestions = new List<AdjectiveQuestion>(allQuestions);
        Shuffle(roundQuestions);
        if (roundQuestions.Count > roundLength)
            roundQuestions = roundQuestions.GetRange(0, roundLength);

        currIndex = -1;
        UpdateHUD(0, roundQuestions.Count);
        NextQuestion();
    }

    void UpdateHUD(int solved, int total)
    {
        if (scoreText) scoreText.text = $"Score: {score}";
        if (progressText) progressText.text = $"{solved}/{total}";
    }

    void NextQuestion()
    {
        // Stop any audio from previous question
        StopQuestionAudio();

        currIndex++;
        if (currIndex >= roundQuestions.Count)
        {
            ShowEndScreen();
            return;
        }

        inputLocked = false;

        var q = roundQuestions[currIndex];

        // [NEW] Start the audio loop for this question
        if (questionAudioSource && q.questionAudio)
        {
            audioRepeatCoroutine = StartCoroutine(PlayAudioLoop(q.questionAudio));
        }

        // Display question image
        if (questionImage)
        {
            questionImage.sprite = q.questionSprite;
            questionImage.gameObject.SetActive(true);
        }

        // Set up the two option buttons (no shuffling - display in order)
        if (optionButtons.Length >= 2)
        {
            optionButtons[0].Bind(this, q.option1Sprite, q.correctIndex == 0);
            optionButtons[1].Bind(this, q.option2Sprite, q.correctIndex == 1);
        }

        UpdateHUD(currIndex, roundQuestions.Count);
    }

    // [NEW] Coroutine to play audio immediately and then every 15 seconds
    IEnumerator PlayAudioLoop(AudioClip clip)
    {
        questionAudioSource.clip = clip;
        
        while (true) // Infinite loop, will be stopped by StopCoroutine
        {
            questionAudioSource.Play();
            yield return new WaitForSeconds(audioRepeatInterval);
        }
    }

    // [NEW] Helper to clean up audio
    void StopQuestionAudio()
    {
        if (audioRepeatCoroutine != null)
        {
            StopCoroutine(audioRepeatCoroutine);
            audioRepeatCoroutine = null;
        }
        
        if (questionAudioSource)
        {
            questionAudioSource.Stop();
        }
    }

    public void SubmitAnswer(AdjectiveOptionButton btn)
    {
        if (inputLocked) return;
        inputLocked = true;

        // [NEW] Stop the question audio immediately upon answering
        StopQuestionAudio();

        bool isCorrect = btn.IsCorrect;
        if (isCorrect) score++;

        if (sfxSource) sfxSource.PlayOneShot(isCorrect ? correctSfx : wrongSfx);

        // Lock visuals on selection
        foreach (var b in optionButtons)
        {
            if (b == btn)
            {
                if (isCorrect) b.SetCorrect();
                else b.SetWrong();
            }
            else
            {
                // Show the correct answer
                if (b.IsCorrect)
                    b.SetCorrect();
                else
                    b.SetDisabled();
            }
        }

        StartCoroutine(AfterAnswer(isCorrect));
    }

    IEnumerator AfterAnswer(bool wasCorrect)
    {
        // Confetti only on correct
        if (wasCorrect && confettiPrefab && confettiSpawnPoint)
        {
            activeConfetti = Instantiate(confettiPrefab, confettiSpawnPoint.position, confettiSpawnPoint.rotation);
            activeConfetti.Play();
        }

        // Wait long enough for the reveal and confetti
        float waitTime = answerRevealTime;
        if (wasCorrect && activeConfetti != null)
            waitTime = Mathf.Max(answerRevealTime, confettiLifetime);

        yield return new WaitForSeconds(waitTime);

        if (activeConfetti != null)
        {
            Destroy(activeConfetti.gameObject);
            activeConfetti = null;
        }

        // Reset buttons and proceed
        foreach (var b in optionButtons) b.ResetVisual();
        NextQuestion();
    }

    void HideGameplayUI()
    {
        if (questionImage) questionImage.gameObject.SetActive(false);

        if (optionButtons != null)
            foreach (var b in optionButtons)
                if (b) b.gameObject.SetActive(false);

        if (scoreText) scoreText.gameObject.SetActive(false);
        if (progressText) progressText.gameObject.SetActive(false);
    }

    void ShowEndScreen()
    {
        // [NEW] Ensure audio is stopped
        StopQuestionAudio();

        // Clean up any leftover confetti
        if (activeConfetti != null)
        {
            Destroy(activeConfetti.gameObject);
            activeConfetti = null;
        }

        HideGameplayUI();

        var panel = FindObjectOfType<WordRoundEndPanelUI>(true);
        if (panel) panel.Show(score, roundQuestions.Count);
    }

    // Utility
    static void Shuffle<T>(IList<T> list)
    {
        for (int i = list.Count - 1; i > 0; i--)
        {
            int j = Random.Range(0, i + 1);
            (list[i], list[j]) = (list[j], list[i]);
        }
    }
}