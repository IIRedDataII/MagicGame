using UnityEngine;

public class Pattern : MonoBehaviour
{
    
    private const float Delay = 1f / 100f;
    private const int Step = 1;
    
    [SerializeField] private Material material;
    [SerializeField] private Texture2D pattern;

    private int _patternWidth;
    private int _patternOffset;
    private float _timePassed;

    private void Start()
    {
        _patternWidth = pattern.width;
        _patternOffset = 0;
        _timePassed = 0f;
    }

    private void Update()
    {
        if (_timePassed >= Delay)
        {
            _patternOffset += Step;
            if (_patternOffset % _patternWidth == 0)
                _patternOffset = 0;
            material.SetInt(Shader.PropertyToID("_PatternOffset"), _patternOffset);
            _timePassed = 0f;
        }
        _timePassed += Time.deltaTime;
    }

    private void OnDestroy()
    {
        material.SetInt(Shader.PropertyToID("_PatternOffset"), 0);
    }

}
