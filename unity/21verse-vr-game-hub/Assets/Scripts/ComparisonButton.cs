using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class ComparisonButton : MonoBehaviour
{
    [Header("Button Config")]
    public string symbol; // "<", ">", or "=" (optional; label text will be used if this is empty)

    [Header("Visual Feedback Colors")]
    public Color normalColor = Color.white;
    public Color correctColor = Color.green;
    public Color wrongColor = Color.red;
    public Color disabledColor = Color.gray;

    private Button button;
    private Image buttonImage;
    private TextMeshProUGUI buttonText;
    private NumberComparisonGameController controller;
    private bool isCorrect;

    public bool IsCorrect => isCorrect;

    void Awake()
    {
        button = GetComponent<Button>();
        buttonImage = GetComponent<Image>();
        buttonText = GetComponentInChildren<TextMeshProUGUI>(true);

        if (button)
        {
            button.onClick.RemoveAllListeners();
            button.onClick.AddListener(OnClick);
        }

        // If a symbol is set in the Inspector, push it to the label once.
        if (buttonText && !string.IsNullOrEmpty(symbol))
            buttonText.text = symbol;
    }

    public void Bind(NumberComparisonGameController ctrl, bool correct)
    {
        controller = ctrl;
        isCorrect = correct;
        ResetVisual();
    }

    void OnClick()
    {
        if (controller != null)
            controller.SubmitAnswer(this);
    }

    // ---- NEW: used by controller ----
    public void SetInteractable(bool value)
    {
        if (button) button.interactable = value;
        if (buttonImage) buttonImage.color = value ? normalColor : disabledColor;
    }

    // ---- NEW: normalize whatever is visible to ASCII '<', '=', '>' ----
    public char GetSymbolChar()
    {
        string s = (buttonText ? buttonText.text : symbol) ?? "";
        s = s.Trim();

        // map common look-alikes to ASCII
        if (s == "≤" || s == "‹" || s == "≺") return '<';
        if (s == "≥" || s == "›" || s == "≻") return '>';
        return s.Length > 0 ? s[0] : '?';
    }
    // ---------------------------------

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
