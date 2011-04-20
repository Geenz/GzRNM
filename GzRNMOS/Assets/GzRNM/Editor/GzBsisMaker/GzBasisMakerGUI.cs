using UnityEngine;
using UnityEditor;
using System.Collections;

public class GzBasisMakerGUI : ScriptableWizard
{
    public string basisname;
    public Vector3 basisx;
    public Vector3 basisy;
    public Vector3 basisz;

    [MenuItem("Utilities/GzRNM/Basis Maker")]

    static void CreateWizard()
    {
        ScriptableWizard.DisplayWizard<GzBasisMakerGUI>("Create SSBump");
    }

    void OnWizardCreate()
    {
        GzBasisMakerUtil.MakeBasis(basisname, basisx, basisy, basisz);
    }

    void OnWizardUpdate()
    {
        helpString = "Input a name for your basis.\nThen input 3 basis vectors to encode them into basis maps for use with 3D applications.";
    }
}
