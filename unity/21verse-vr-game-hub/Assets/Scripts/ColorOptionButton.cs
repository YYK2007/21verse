using UnityEngine;
using UnityEngine.UI;

public class ColorOptionButton : MonoBehaviour
{
    [SerializeField] private Button button;
    [SerializeField] private Image buttonBackground; // use the Button's Image component

    private FruitColor colorValue;
    private System.Action<FruitColor> onClick;

    public void Init(FruitColor color, Color displayColor, System.Action<FruitColor> callback)
    {
        colorValue = color;
        onClick = callback;

        if (!button) button = GetComponent<Button>();
        if (!buttonBackground) buttonBackground = GetComponent<Image>();

        if (buttonBackground) buttonBackground.color = displayColor;

        button.onClick.RemoveAllListeners();
        button.onClick.AddListener(() => onClick?.Invoke(colorValue));
        button.interactable = true;
    }

    public void SetInteractable(bool state)
    {
        if (button) button.interactable = state;
    }
}
