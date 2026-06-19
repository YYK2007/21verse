using UnityEngine;
using UnityEngine.UI;

public class AdjectiveOptionButton : MonoBehaviour
{
    [Header("Visual Feedback Colors")]
    public Color normalColor = Color.white;
    public Color correctColor = Color.green;
    public Color wrongColor = Color.red;
    public Color disabledColor = Color.gray;

    [Header("References")]
    public Image optionImage; // The image showing the adjective representation

    private Button button;
    private Image buttonImage;
    private AdjectiveComparisonGameController controller;
    private bool isCorrect;

    public bool IsCorrect => isCorrect;

    void Awake()
    {
        button = GetComponent<Button>();
        buttonImage = GetComponent<Image>();

        if (button)
        {
            button.onClick.AddListener(OnClick);
        }
    }

    public void Bind(AdjectiveComparisonGameController ctrl, Sprite sprite, bool correct)
    {
        controller = ctrl;
        isCorrect = correct;

        if (optionImage)
        {
            optionImage.sprite = sprite;
        }

        ResetVisual();
    }

    void OnClick()
    {
        if (controller != null)
        {
            controller.SubmitAnswer(this);
        }
    }

    public void SetCorrect()
    {
        if (buttonImage) buttonImage.color = correctColor;
        if (button) button.interactable = false;
    }

    public void SetWrong()
    {
        if (buttonImage) buttonImage.color = wrongColor;
        if (button) button.interactable = false;
    }

    public void SetDisabled()
    {
        if (buttonImage) buttonImage.color = disabledColor;
        if (button) button.interactable = false;
    }

    public void ResetVisual()
    {
        if (buttonImage) buttonImage.color = normalColor;
        if (button) button.interactable = true;
    }
}