using UnityEngine;
using System.Collections;
using UnityEditor;

public class screenShaderGUI : ShaderGUI
{
    MaterialProperty _MainTexProp;
    MaterialProperty _MaskTexProp;
    MaterialProperty _ColorProp;
    MaterialProperty _GridSizeProp;
    MaterialProperty _LineWidthProp;
    MaterialProperty _BlurProp;
    MaterialProperty _SpeedProp;
    MaterialProperty _TurnProp;
    MaterialProperty _SHADOW_ONPorp;
    MaterialProperty _EMISSION_ONProp;
    MaterialProperty _EmissionProp;
    MaterialProperty _EmissionColorProp;

    public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] properties)
    {
        var material = (Material)materialEditor.target;
        // base.OnGUI (materialEditor, properties);

        _MainTexProp = FindProperty("_MainTex", properties, false);
        _MaskTexProp = FindProperty("_MaskTex", properties,false);
        _ColorProp = FindProperty("_Color", properties, false);
        _GridSizeProp = FindProperty("_GridSize", properties, false);
        _LineWidthProp = FindProperty("_LineWidth", properties, false);
        _BlurProp = FindProperty("_Blur", properties, false);
        _SpeedProp = FindProperty("_Speed", properties, false);
        _TurnProp = FindProperty("_Turn", properties, false);
        _SHADOW_ONPorp = FindProperty("_SHADOW_ON", properties, false);
        _EMISSION_ONProp = FindProperty("_EMISSION_ON", properties, false);
        _EmissionProp = FindProperty("_Emission", properties, false);
        _EmissionColorProp = FindProperty("_EmissionColor", properties, false);

        EditorGUI.BeginChangeCheck();
        {
            materialEditor.TexturePropertySingleLine(new GUIContent("Main Texture"), _MainTexProp, _ColorProp);
            using(new EditorGUI.IndentLevelScope())
            {
                materialEditor.TextureScaleOffsetProperty(_MainTexProp);
            }
            EditorGUILayout.Space();

            materialEditor.TexturePropertySingleLine(new GUIContent("Mask Texture"), _MaskTexProp);
            EditorGUILayout.Space();

            materialEditor.ShaderProperty(_GridSizeProp, "GridSize");
            materialEditor.ShaderProperty(_LineWidthProp, "LineWidth");
            materialEditor.ShaderProperty(_BlurProp, "Blur");
            materialEditor.ShaderProperty(_SpeedProp, "Speed");

            if(GUILayout.Button("Reset"))
            {
                material.SetInt("_GridSize", 3);
                material.SetFloat("_LineWidth", 0.5f);
                material.SetFloat("_Blur", 0.3f);
                material.SetFloat("_Speed", 1f);
            }
            EditorGUILayout.Space();

            materialEditor.ShaderProperty(_TurnProp, "Turn");
            materialEditor.ShaderProperty(_SHADOW_ONPorp, "Shadow On");
            materialEditor.ShaderProperty(_EMISSION_ONProp, "Emission On");
            var showEmissionOption = _EMISSION_ONProp.floatValue;
            if(showEmissionOption > 0)
            {
                EditorGUI.indentLevel ++;
                materialEditor.ShaderProperty(_EmissionColorProp, "Emission Color");
                materialEditor.ShaderProperty(_EmissionProp, "Emission");
            }
            EditorGUILayout.Space();
        }
        EditorGUI.EndChangeCheck();
    }
}
