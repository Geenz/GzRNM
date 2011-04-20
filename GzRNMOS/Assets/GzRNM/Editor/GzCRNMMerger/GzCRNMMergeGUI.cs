/*
    GzRNM - A shader library for Radiosity Normal Mapping in Unity3D!    
    Copyright (C) 2011  Jonathan Goodman

    This library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public
    License along with this library; if not, write to the Free Software
    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
*/
using UnityEngine;
using UnityEditor;
using System.Collections;

public class GzCRNMMergeGUI : ScriptableWizard {
    public Texture2D RNMX;
    public Texture2D RNMY;
    public Texture2D RNMZ;


    [MenuItem("Utilities/GzRNM/CRNM Merger")]

    static void CreateWizard()
    {
        ScriptableWizard.DisplayWizard<GzCRNMMergeGUI>("Create CRNM");
    }

    void OnWizardCreate()
    {
        Texture2D[] RNM = new Texture2D[3];
        RNM[0] = RNMX;
        RNM[1] = RNMY;
        RNM[2] = RNMZ;
        GzCRNMMergeUtil.FlattenCRNM(RNM);
    }

    void OnWizardUpdate()
    {
        helpString = "Select 3 Directional Lightmaps, and click Create.";
    }

	/*
	// Update is called once per frame
	void OnGUI() {
        for (int i = 0; i < 3; i++)
        {
            string basisText;
            switch (i)
            {
                case 0:
                    basisText = "RNM Basis X";
                    break;
                case 1:
                    basisText = "RNM Basis Y";
                    break;
                case 2:
                    basisText = "RNM Basis Z";
                    break;
                default:
                    basisText = "RNM Basis";
                    break;
            }
            RNM[i] = EditorGUILayout.ObjectField(basisText, RNM[i], typeof(Texture)) as Texture2D;
        }

        optToggle[0] = GUILayout.Toggle(optToggle[0], "Normalize?");
        optToggle[1] = GUILayout.Toggle(optToggle[1], "Average?");
        optToggle[2] = GUILayout.Toggle(optToggle[2], "Summate?");

        if(GUILayout.Button("Create CRNM"))
        {
            GzCRNMMergeUtil.FlattenCRNM(RNM, optToggle);
        }
	}*/
}
