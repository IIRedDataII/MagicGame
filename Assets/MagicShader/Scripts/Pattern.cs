using UnityEngine;

public class Pattern : MonoBehaviour
{
    
    private const float Delay = 1f / 100f;
    private const int Speed = 10;
    
    [SerializeField] private Material material;
    [SerializeField] private Texture2D pattern;
    [SerializeField] private Texture2D[] patterns;
    [SerializeField] private bool move;

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
        if (Input.GetKeyDown(KeyCode.Mouse1))
            move = !move;
        
        if (move)
        {
            if (_timePassed >= Delay)
            {
                material.SetTexture(Shader.PropertyToID("_Pattern"), patterns[Random.Range(0, patterns.Length)]);
                _patternOffset = Random.Range(0, 300);
                /*_patternOffset += Speed;
                if (_patternOffset % _patternWidth == 0)
                    _patternOffset = 0;*/
                material.SetInt(Shader.PropertyToID("_PatternOffset"), _patternOffset);
                _timePassed = 0f;
            }
            _timePassed += Time.deltaTime;
        }
    }

    private void OnDestroy()
    {
        material.SetInt(Shader.PropertyToID("_PatternOffset"), 0);
        material.SetTexture(Shader.PropertyToID("_Pattern"), pattern);
    }

}
