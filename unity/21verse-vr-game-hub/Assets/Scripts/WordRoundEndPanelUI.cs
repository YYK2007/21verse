using UnityEngine;
using UnityEngine.UI;
using TMPro;
using UnityEngine.SceneManagement;

public class WordRoundEndPanelUI : MonoBehaviour
{
    public TextMeshProUGUI summaryText;
    public Button replayButton;
    public Button menuButton;

    void Awake()
    {
        gameObject.SetActive(false);
        if (replayButton) replayButton.onClick.AddListener(() =>
            SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex));
        if (menuButton) menuButton.onClick.AddListener(() =>
            SceneManager.LoadScene("MainMenu"));
    }

    public void Show(int score, int total)
    {
        if (summaryText) summaryText.text = $"Great job!\n{score} / {total}";
        gameObject.SetActive(true);
    }
}
