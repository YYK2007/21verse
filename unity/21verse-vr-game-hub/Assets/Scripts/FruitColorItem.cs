using UnityEngine;

public enum FruitColor
{
    Red,
    Green,
    Yellow,
    Orange
}

[CreateAssetMenu(menuName = "21Verse/Fruit Color Item")]
public class FruitColorItem : ScriptableObject
{
    public Sprite fruitSprite;
    public FruitColor correctColor;
    public AudioClip questionAudio; // "What color is this fruit?"
}
