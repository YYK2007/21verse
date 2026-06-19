using UnityEngine;
using UnityEngine.UI;
using TMPro;
using System.Collections;
using System.Collections.Generic;

public class NumberGameControllerUI : MonoBehaviour
{
    [Header("Round Config")]
    public int roundLength = 10;
    public int sequenceLength = 5;     // keep at 5
    public int step = 5;
    public int minStart = 0;
    public int maxValue = 100;

    [Tooltip("How long to keep the filled answer visible before moving on")]
    public float correctRevealTime = 1.2f;

    [Tooltip("Short pause after a wrong press to prevent double-click spam")]
    public float wrongRetryPause = 0.3f;

    [Tooltip("How long the confetti should last (used on correct)")]
    public float confettiLifetime = 1.2f;

    [Header("UI References")]
    public SequenceBoxUI[] sequenceBoxes;        // 5 boxes in order (left→right)
    public OptionNumberButtonUI[] optionButtons; // exactly 3 answer buttons
    public TextMeshProUGUI scoreText;
    public TextMeshProUGUI progressText;

    [Header("FX / Audio")]
    public ParticleSystem confettiPrefab;
    public Transform confettiSpawnPoint;

    public AudioSource sfxSource;
    public AudioClip correctSfx;
    public AudioClip wrongSfx;

    [Tooltip("Your voice line: 'جرّب مرة أخرى' / 'Try again'")]
    public AudioClip tryAgainVoiceSfx;

    // runtime
    private int currIndex = -1;
    private int score = 0;
    private bool inputLocked = false;

    private int[] currSequence;     // len = sequenceLength
    private int currMissingIndex;   // 0..sequenceLength-1
    private int currCorrectValue;   // value that fills the blank
    private ParticleSystem activeConfetti;

    // Scoring gates
    private bool awardedPointThisQuestion = false;     // prevents double-award on same question
    private bool disqualifyScoreThisQuestion = false;  // if any wrong attempt happens, no points for this question

    void Start() => StartRound();

    public void StartRound()
    {
        score = 0;
        currIndex = -1;
        UpdateHUD(0, roundLength);
        NextQuestion();
    }

    void UpdateHUD(int solved, int total)
    {
        if (scoreText)    scoreText.text = $"Score: {score}";
        if (progressText) progressText.text = $"{solved}/{total}";
    }

    void NextQuestion()
    {
        currIndex++;
        if (currIndex >= roundLength)
        {
            ShowEndScreen();
            return;
        }

        inputLocked = false;
        awardedPointThisQuestion = false;
        disqualifyScoreThisQuestion = false; // reset: allow point unless a wrong happens first

        // Validate UI
        if (sequenceBoxes == null || sequenceBoxes.Length < sequenceLength)
        {
            Debug.LogError("[NumberGame] Assign 5 SequenceBoxUI items in order.");
            ShowEndScreen();
            return;
        }
        if (optionButtons == null || optionButtons.Length < 3)
        {
            Debug.LogError("[NumberGame] Assign exactly 3 option buttons.");
            ShowEndScreen();
            return;
        }

        // Generate a new sequence and options
        GenerateSequenceAndOptions(out int[] options, out int correctIndex);

        // Render sequence with an EMPTY missing box
        for (int i = 0; i < sequenceLength; i++)
        {
            if (i == currMissingIndex) sequenceBoxes[i].SetMissing();
            else                       sequenceBoxes[i].SetValue(currSequence[i]);
        }

        // Bind buttons (shuffle display)
        var order = new List<int> { 0, 1, 2 };
        Shuffle(order);
        for (int i = 0; i < 3; i++)
        {
            var btn = optionButtons[i];
            if (!btn) continue;
            int optIdx = order[i];
            bool isCorrect = (optIdx == correctIndex);
            btn.Bind(this, options[optIdx], isCorrect);
        }

        UpdateHUD(currIndex, roundLength);
    }

    void GenerateSequenceAndOptions(out int[] options, out int correctIndex)
    {
        int safeStep = Mathf.Max(1, Mathf.Abs(step)); // force positive step >= 1

        // last value must be <= maxValue
        int maxStartAllowed = maxValue - safeStep * (sequenceLength - 1);
        maxStartAllowed = Mathf.Max(maxStartAllowed, minStart);

        // snap start to multiples of step
        int minK = Mathf.CeilToInt((float)minStart / safeStep);
        int maxK = Mathf.FloorToInt((float)maxStartAllowed / safeStep);
        if (maxK < minK) { minK = 0; maxK = 0; } // fallback guard

        int start = Random.Range(minK, maxK + 1) * safeStep;

        // strictly increasing: start, start+step, ...
        currSequence = new int[sequenceLength];
        for (int i = 0; i < sequenceLength; i++)
            currSequence[i] = start + i * safeStep;

        currMissingIndex = Random.Range(0, sequenceLength);
        currCorrectValue = currSequence[currMissingIndex];

        var distractors = GenerateDistractors(currCorrectValue, 2, safeStep);

        options = new int[3] { currCorrectValue, distractors[0], distractors[1] };
        correctIndex = 0; // we shuffle when binding
    }

    List<int> GenerateDistractors(int exclude, int count, int safeStep)
    {
        var set = new HashSet<int>();
        int[] seeds = new int[] { exclude - safeStep, exclude + safeStep, exclude - 2 * safeStep, exclude + 2 * safeStep };
        foreach (var s in seeds)
            if (s >= 0 && s <= maxValue && s != exclude) set.Add(s);

        int attempts = 0;
        while (set.Count < count && attempts < 100)
        {
            int k = Random.Range(0, (maxValue / safeStep) + 1);
            int val = k * safeStep;
            if (val != exclude) set.Add(val);
            attempts++;
        }
        while (set.Count < count) set.Add(Mathf.Clamp(exclude + safeStep * (set.Count + 1), 0, maxValue));

        var list = new List<int>(set);
        Shuffle(list);
        if (list.Count > count) list = list.GetRange(0, count);
        return list;
    }

    public void SubmitAnswer(OptionNumberButtonUI btn)
    {
        if (inputLocked || btn == null) return;
        inputLocked = true;

        // Defensive correctness check: recompute from button label if available
        bool isCorrect = btn.IsCorrect;
        int pickedValue;
        var pickedLabel = btn.GetComponentInChildren<TextMeshProUGUI>();
        if (pickedLabel != null && int.TryParse(pickedLabel.text, out pickedValue))
            isCorrect = (pickedValue == currCorrectValue);

        if (isCorrect)
        {
            // Award point only if: not already awarded, and no wrong attempt happened earlier
            if (!awardedPointThisQuestion && !disqualifyScoreThisQuestion)
            {
                score++;
                awardedPointThisQuestion = true;
                if (scoreText) scoreText.text = $"Score: {score}";
            }

            if (sfxSource && correctSfx) sfxSource.PlayOneShot(correctSfx);

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
            // Mark this question as disqualified for scoring (any wrong attempt removes point eligibility)
            disqualifyScoreThisQuestion = true;

            if (sfxSource)
            {
                var clip = tryAgainVoiceSfx ? tryAgainVoiceSfx : wrongSfx;
                if (clip) sfxSource.PlayOneShot(clip);
            }

            btn.gameObject.SetActive(false);
            StartCoroutine(UnlockAfterWrong());
        }
    }

    IEnumerator HandleCorrectThenAdvance()
    {
        if (currMissingIndex >= 0 && currMissingIndex < sequenceBoxes.Length)
            sequenceBoxes[currMissingIndex].FillWithAnswer(currCorrectValue);

        if (confettiPrefab && confettiSpawnPoint)
        {
            activeConfetti = Instantiate(confettiPrefab, confettiSpawnPoint.position, confettiSpawnPoint.rotation);
            activeConfetti.Play();
        }

        float waitTime = activeConfetti ? Mathf.Max(correctRevealTime, confettiLifetime) : correctRevealTime;
        yield return new WaitForSeconds(waitTime);

        if (activeConfetti) { Destroy(activeConfetti.gameObject); activeConfetti = null; }

        foreach (var b in optionButtons) if (b) b.ResetVisual();

        NextQuestion();
    }

    IEnumerator UnlockAfterWrong()
    {
        yield return new WaitForSeconds(wrongRetryPause);
        inputLocked = false; // allow another attempt on the same question
    }

    void ShowEndScreen()
    {
        if (sequenceBoxes != null) foreach (var box in sequenceBoxes) if (box) box.gameObject.SetActive(false);
        if (optionButtons  != null) foreach (var b in optionButtons)   if (b)   b.gameObject.SetActive(false);
        if (scoreText)    scoreText.gameObject.SetActive(false);
        if (progressText) progressText.gameObject.SetActive(false);

        if (activeConfetti) { Destroy(activeConfetti.gameObject); activeConfetti = null; }

        var panel = FindObjectOfType<WordRoundEndPanelUI>(true); // reuse your end panel
        if (panel) panel.Show(score, roundLength);
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
