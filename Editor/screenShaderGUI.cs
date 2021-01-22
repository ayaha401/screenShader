using UnityEngine;
using UnityEditor;

public class screenShaderGUI : ShaderGUI
{
    public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] properties)
    {
        var material = (Material)materialEditor.target;
        base.OnGUI (materialEditor, properties);


        if(GUILayout.Button("Reset"))
        {
            material.SetInt("_GridSize", 3);
            material.SetFloat("_LineWidth", 0.5f);
            material.SetFloat("_Blur", 0.3f);
            material.SetFloat("_Speed", 1f);
        }
    }
}
