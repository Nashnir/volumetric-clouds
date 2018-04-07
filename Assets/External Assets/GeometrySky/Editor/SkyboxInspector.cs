using UnityEngine;
using UnityEditor;

public class SkyboxInspector : MaterialEditor
{

    public override void OnInspectorGUI()
    {
        serializedObject.Update();
        Material t = (Material)target;

        if (isVisible)
        {
            //GUILayout.Label("Sun Parameters");
            EditorGUI.BeginChangeCheck();

            DefaultShaderProperty(GetMaterialProperty(targets, "_MainTex"), "Starmap texture");
            DefaultShaderProperty(GetMaterialProperty(targets, "_StarIntensity"), "Star Intensity");
            if (t.GetFloat("_StarIntensity") > 0.01)
            {
                t.EnableKeyword("STARS_ON");
            } else
            {
                t.DisableKeyword("STARS_ON");
            }


            GUILayout.BeginVertical(GUI.skin.GetStyle("HelpBox"));
            EditorGUILayout.LabelField("Background", EditorStyles.boldLabel);

            ColorProperty(GetMaterialProperty(targets, "_SkyColor1"), "Top Color");
            ColorProperty(GetMaterialProperty(targets, "_SkyColor2"), "Horizon Color");
            ColorProperty(GetMaterialProperty(targets, "_SkyColor3"), "Bottom Color");

            DefaultShaderProperty(GetMaterialProperty(targets, "_SkyBlend1"), "Top Blend");
            DefaultShaderProperty(GetMaterialProperty(targets, "_SkyBlend2"), "Bottom Blend");
            DefaultShaderProperty(GetMaterialProperty(targets, "_SkyHorizonSharpness"), "Horizon Sharpness");

            GUILayout.EndVertical();

            EditorGUILayout.Space();

            GUILayout.BeginVertical(GUI.skin.GetStyle("HelpBox"));
            EditorGUILayout.LabelField("Sun", EditorStyles.boldLabel);

            ColorProperty(GetMaterialProperty(targets, "_SunColor"), "Sun Color");
            FloatProperty(GetMaterialProperty(targets, "_SunSize"), "Sun Size");
            FloatProperty(GetMaterialProperty(targets, "_SunSharpness"), "Sun Sharpness");
            DefaultShaderProperty(GetMaterialProperty(targets, "_SunHaloSize"), "Sun Halo Size");
            DefaultShaderProperty(GetMaterialProperty(targets, "_SunHaloIntensity"), "Sun Halo Intensity");

            GUILayout.EndVertical();
            EditorGUILayout.Space();

            GUILayout.BeginVertical(GUI.skin.GetStyle("HelpBox"));
            EditorGUILayout.LabelField("Halo", EditorStyles.boldLabel);

            ColorProperty(GetMaterialProperty(targets, "_HaloColor"), "Halo Color");
            DefaultShaderProperty(GetMaterialProperty(targets, "_HaloSize"), "Halo Size");
            DefaultShaderProperty(GetMaterialProperty(targets, "_HaloIntensity"), "Halo Intensity");

            EditorGUILayout.EndVertical();

            if (EditorGUI.EndChangeCheck())
            {
                PropertiesChanged();
            }
        }
    }
}
