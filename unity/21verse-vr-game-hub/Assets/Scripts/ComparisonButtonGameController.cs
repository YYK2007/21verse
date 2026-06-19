using UnityEngine;
using TMPro;
using System.Collections;

public class NumberComparisonGameController : MonoBehaviour
{
    [Header("Round Config")]
    public int roundLength = 10;
    public float afterAnswerDelay = 0.8f;
    public float answerRevealTime = 1.2f;

    [Header("UI References")]
    public TextMeshProUGUI number1Text;
    public TextMeshProUGUI number2Text;
    public TextMeshProUGUI answerRevealText;
    public ComparisonButton[] comparisonButtons;
    public TextMeshProUGUI scoreText;
    public TextMeshProUGUI progressText;

    [Header("FX / Audio")]
    public ParticleSystem confettiPrefab;
    public Transform confettiSpawnPoint;
    public float confettiLifetime = 1.2f;
    public AudioSource sfxSource;
    public AudioClip correctSfx;
    public AudioClip wrongSfx;

    // Runtime
    private int currQuestion = -1;
    private int score = 0;
    private bool inputLocked = false;
    private bool firstTry = true;
    private ParticleSystem activeConfetti;
    private int currentNumber1;
    private int currentNumber2;
    private char correctSign; // '<', '=', '>'

    void Start() => StartRound();

    public void StartRound()
    {
        score = 0;
        currQuestion = -1;
        UpdateHUD(0, roundLength);
        NextQuestion();
    }

    void UpdateHUD(int solved, int total)
    {
        if (scoreText) scoreText.text = $"Score: {score}";
        if (progressText) progressText.text = $"{solved}/{total}";
    }

    void NextQuestion()
    {
        currQuestion++;
        if (currQuestion >= roundLength)
        {
            ShowEndScreen();
            return;
        }

        inputLocked = false;
        firstTry = true;

        if (answerRevealText) answerRevealText.gameObject.SetActive(false);

        // Reset buttons fully for the new round
        foreach (var b in comparisonButtons)
        {
            if (!b) continue;
            b.ResetVisual();
            b.SetInteractable(true);
        }

        // Generate two random numbers (1..9)
        currentNumber1 = Random.Range(1, 10);
        currentNumber2 = Random.Range(1, 10);

        if (number1Text) number1Text.text = currentNumber1.ToString();
        if (number2Text) number2Text.text = currentNumber2.ToString();

        // Compute correct sign
        if (currentNumber1 < currentNumber2)      correctSign = '<';
        else if (currentNumber1 > currentNumber2) correctSign = '>';
        else                                       correctSign = '=';

        // Bind buttons robustly using the *visible* label
        foreach (var btn in comparisonButtons)
        {
            var sym = btn.GetSymbolChar(); // normalized
            btn.Bind(this, sym == correctSign);
        }

        UpdateHUD(currQuestion, roundLength);
    }

    public void SubmitAnswer(ComparisonButton btn)
    {
        if (inputLocked) return;

        if (!btn.IsCorrect)
        {
            // Wrong: don't advance; disable just this button; mark not-first-try
            firstTry = false;
            if (sfxSource && wrongSfx) sfxSource.PlayOneShot(wrongSfx);
            btn.SetWrong();
            return;
        }

        // Correct
        inputLocked = true;

        if (firstTry)
        {
            score++;
            if (scoreText) scoreText.text = $"Score: {score}";
        }

        if (sfxSource && correctSfx) sfxSource.PlayOneShot(correctSfx);

        foreach (var b in comparisonButtons)
        {
            if (b == btn) b.SetCorrect();
            else b.SetDisabled();
        }

        StartCoroutine(AfterAnswer());
    }

    IEnumerator AfterAnswer()
    {
        if (answerRevealText)
        {
            answerRevealText.text = correctSign.ToString();
            answerRevealText.gameObject.SetActive(true);
        }

        if (confettiPrefab && confettiSpawnPoint)
        {
            activeConfetti = Instantiate(confettiPrefab, confettiSpawnPoint.position, confettiSpawnPoint.rotation);
            activeConfetti.Play();
        }

        float waitTime = Mathf.Max(answerRevealTime, activeConfetti ? confettiLifetime : 0f);
        yield return new WaitForSeconds(waitTime);

        if (activeConfetti)
        {
            Destroy(activeConfetti.gameObject);
            activeConfetti = null;
        }

        NextQuestion();
    }

    void HideGameplayUI()
    {
        if (number1Text) number1Text.gameObject.SetActive(false);
        if (number2Text) number2Text.gameObject.SetActive(false);
        if (answerRevealText) answerRevealText.gameObject.SetActive(false);

        if (comparisonButtons != null)
            foreach (var b in comparisonButtons)
                if (b) b.gameObject.SetActive(false);

        if (scoreText) scoreText.gameObject.SetActive(false);
        if (progressText) progressText.gameObject.SetActive(false);
    }

    void ShowEndScreen()
    {
        if (activeConfetti)
        {
            Destroy(activeConfetti.gameObject);
            activeConfetti = null;
        }

        HideGameplayUI();

        var panel = FindObjectOfType<WordRoundEndPanelUI>(true);
        if (panel) panel.Show(score, roundLength);
    }
}
