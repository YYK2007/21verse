using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class FruitColorGameController : MonoBehaviour
{
    [Header("Game Data")]
    [SerializeField] private List<FruitColorItem> items;

    [Header("UI - Gameplay")]
    [SerializeField] private Image fruitImage;
    [SerializeField] private Transform optionsParent;
    [SerializeField] private ColorOptionButton optionPrefab;

    [Header("UI - Top HUD")]
    [SerializeField] private TMP_Text scoreText;
    [SerializeField] private TMP_Text progressText; // e.g. "3 / 10"

    [Header("UI - End Panel")]
    [SerializeField] private GameObject endPanel;
    [SerializeField] private TMP_Text endScoreText;
    [SerializeField] private TMP_Text endSummaryText; // optional: correct/wrong breakdown

    [Header("Audio")]
    [SerializeField] private AudioSource voiceSource;
    [SerializeField] private AudioSource feedbackSource;
    [SerializeField] private AudioClip correctSfx;
    [SerializeField] private AudioClip wrongSfx;

    [Header("Round Settings")]
    [SerializeField] private float nextRoundDelay = 0.8f;
    [SerializeField] private bool allowRetryOnWrong = true;
    [SerializeField] private bool shuffleAtStart = true;

    [Header("Scoring")]
    [SerializeField] private int pointsPerCorrect = 1;
    [SerializeField] private int pointsPerWrong = 0; // set to -1 if you want penalty

    [Header("Colors")]
    [SerializeField] private Color red = Color.red;
    [SerializeField] private Color green = Color.green;
    [SerializeField] private Color yellow = Color.yellow;
    [SerializeField] private Color orange = new Color(1f, 0.5f, 0f);

    // State
    private int currentIndex;
    private FruitColorItem currentItem;
    private bool inputLocked;

    private int score;
    private int correctCount;
    private int wrongCount;

    private void Start()
    {
        // Basic sanity checks (also tells you exactly why buttons didn't show)
        if (items == null || items.Count == 0)
        {
            Debug.LogError("FruitColorGameController: No items assigned.");
            return;
        }
        if (!fruitImage) Debug.LogError("FruitColorGameController: fruitImage not assigned.");
        if (!optionsParent) Debug.LogError("FruitColorGameController: optionsParent not assigned.");
        if (!optionPrefab) Debug.LogError("FruitColorGameController: optionPrefab not assigned (this will cause NO options to spawn).");

        if (shuffleAtStart) Shuffle(items);

        ResetRun();

        if (endPanel) endPanel.SetActive(false);

        LoadRound();
    }

    private void ResetRun()
    {
        currentIndex = 0;
        score = 0;
        correctCount = 0;
        wrongCount = 0;
        UpdateHUD();
    }

    private void LoadRound()
    {
        inputLocked = false;
        ClearOptions();

        // End condition
        if (currentIndex >= items.Count)
        {
            ShowEndPanel();
            return;
        }

        currentItem = items[currentIndex];

        if (fruitImage) fruitImage.sprite = currentItem.fruitSprite;

        if (voiceSource)
        {
            voiceSource.Stop();
            if (currentItem.questionAudio)
                voiceSource.PlayOneShot(currentItem.questionAudio);
        }

        GenerateOptions();
        UpdateHUD();
    }

    private void GenerateOptions()
    {
        if (!optionPrefab || !optionsParent) return;

        // Spawns one option per enum value (Red/Green/Yellow/Orange).
        foreach (FruitColor color in System.Enum.GetValues(typeof(FruitColor)))
        {
            ColorOptionButton btn = Instantiate(optionPrefab, optionsParent);
            btn.Init(color, GetUnityColor(color), OnColorSelected);
        }
    }

    private void OnColorSelected(FruitColor selected)
    {
        if (inputLocked) return;
        inputLocked = true;

        bool isCorrect = selected == currentItem.correctColor;

        if (feedbackSource)
            feedbackSource.PlayOneShot(isCorrect ? correctSfx : wrongSfx);

        if (isCorrect)
        {
            correctCount++;
            score += pointsPerCorrect;
            currentIndex++;

            UpdateHUD();
            Invoke(nameof(LoadRound), nextRoundDelay);
        }
        else
        {
            wrongCount++;
            score += pointsPerWrong;
            UpdateHUD();

            if (allowRetryOnWrong)
            {
                inputLocked = false; // try again same fruit
            }
            else
            {
                currentIndex++;
                Invoke(nameof(LoadRound), nextRoundDelay);
            }
        }
    }

    private void UpdateHUD()
    {
        if (scoreText) scoreText.text = $"Score: {score}";
        if (progressText) progressText.text = $"{Mathf.Min(currentIndex + 1, items.Count)} / {items.Count}";
    }

    private void ShowEndPanel()
    {
        ClearOptions();

        if (endPanel) endPanel.SetActive(true);

        if (endScoreText) endScoreText.text = $"Final Score: {score}";
        if (endSummaryText) endSummaryText.text = $"Correct: {correctCount}   Wrong: {wrongCount}";
    }

    // Hook this to your End Panel "Restart" button
    public void RestartGame()
    {
        if (shuffleAtStart) Shuffle(items);

        if (endPanel) endPanel.SetActive(false);

        ResetRun();
        LoadRound();
    }

    private Color GetUnityColor(FruitColor color)
    {
        return color switch
        {
            FruitColor.Red => red,
            FruitColor.Green => green,
            FruitColor.Yellow => yellow,
            FruitColor.Orange => orange,
            _ => Color.white
        };
    }

    private void ClearOptions()
    {
        if (!optionsParent) return;

        for (int i = optionsParent.childCount - 1; i >= 0; i--)
            Destroy(optionsParent.GetChild(i).gameObject);
    }

    private static void Shuffle<T>(IList<T> list)
    {
        for (int i = 0; i < list.Count; i++)
        {
            int j = Random.Range(i, list.Count);
            (list[i], list[j]) = (list[j], list[i]);
        }
    }
}
