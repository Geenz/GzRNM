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
using System.Xml;

public class GzRNMHelperGUI : EditorWindow {
	static public Vector3[] basis = {new Vector3(0,0,0), new Vector3(0,0,0), new Vector3(0,0,0)};
	bool gBasisAdv = false;
	//int gCurrTool = 0;
	//string[] gTools = {"General", "Baking"};
	//bool gExpOkay = false;
	//IniParser gIni = new IniParser("Assets/GzRNM/Editor/Config/gzrnm.ini");
	//bool gBackup = true;
	//bool gLightModeAdv = false;
	//int gLightMode = 0;
	
	[MenuItem("Utilities/GzRNM Helper")]
	
	// Use this for initialization
	static void Init ()
	{
		GzRNMHelperGUI window = (GzRNMHelperGUI)GetWindow<GzRNMHelperGUI>();
		window.title = "RNM Helper";
        basis[0] = GzBasisManager.GetGlobalBasis("basisx");
		basis[1] = GzBasisManager.GetGlobalBasis("basisy");
		basis[2] = GzBasisManager.GetGlobalBasis("basisz");
	}
	
	void OnGUI()
	{
		//gCurrTool = GUILayout.Toolbar(gCurrTool, gTools);
		//if(gCurrTool == 0)
		{
			if(gBasisAdv = EditorGUILayout.Foldout(gBasisAdv, "Advanced Basis Controls"))
			{
				basis[0] = EditorGUILayout.Vector3Field("RNM Basis X", basis[0]);
				basis[1] = EditorGUILayout.Vector3Field("RNM Basis Y", basis[1]);
				basis[2] = EditorGUILayout.Vector3Field("RNM Basis Z", basis[2]);
				EditorGUILayout.BeginHorizontal();
				GUILayout.FlexibleSpace();
				if(GUILayout.Button("Cancel"))
				{
					basis[0] = GzBasisManager.GetGlobalBasis("basisx");
					basis[1] = GzBasisManager.GetGlobalBasis("basisy");
					basis[2] = GzBasisManager.GetGlobalBasis("basisz");
				}
				if(GUILayout.Button("Apply Basis"))
        	    {
            	    GzBasisManager.SetBasis(basis);
            	}

				EditorGUILayout.EndHorizontal();
				GUILayout.Label("Note: You _MUST_ create basismaps after using this feature! Afterwards, you must rebake your lighting in your 3D application!", EditorStyles.wordWrappedLabel);
        	    EditorGUILayout.BeginHorizontal();
            	GUILayout.FlexibleSpace();
				if(GUILayout.Button("Create Basismaps"))
				{
					GzBasisMakerUtil.MakeBasis("", basis[0], basis[1], basis[2]);
				}
	            GUILayout.FlexibleSpace();
    	        EditorGUILayout.EndHorizontal();
			}
			EditorGUILayout.BeginHorizontal();
			if(GUILayout.Button("Create CRNM"))
			{
				ScriptableWizard.DisplayWizard<GzCRNMMergeGUI>("Create CRNM");
			}
			GUILayout.FlexibleSpace();
			if(GUILayout.Button("Create SSBumpmap"))
			{
				ScriptableWizard.DisplayWizard<GzSSBumpConverterGUI>("Create SSBump");
			}
		
			EditorGUILayout.EndHorizontal();
		}
		/*  //NOTE: All of this never quite worked properly, but may be usable in the future.
		    //Uncomment this when the basis work for a new normal botcher is ready to go.
		else if (gCurrTool == 1)
		{
			GUILayout.Label("The baking tool is an experimental feature.\nAs such, USE WITH CAUTION.  You have been warned.", EditorStyles.wordWrappedLabel);
			EditorGUILayout.BeginHorizontal();
			GUILayout.FlexibleSpace();
			gExpOkay = bool.Parse(gIni.GetSetting("BakeSettings", "BakeToolEnabled"));
			gExpOkay = EditorGUILayout.Toggle("Okay", gExpOkay);
			gIni.AddSetting("BakeSettings", "BakeToolEnabled", gExpOkay.ToString());
			gIni.SaveSettings();
			GUILayout.FlexibleSpace();
			EditorGUILayout.EndHorizontal();
			if(gExpOkay)
			{
				gBackup = EditorGUILayout.Toggle("Backup Scene", gBackup);
				string[] lightModes = {"Directional Light Mapping (RNMs)", "Light Vector Mapping"};
				gLightModeAdv = EditorGUILayout.Foldout(gLightModeAdv, "Light Modes");
				if(gLightModeAdv)
					gLightMode = GUILayout.SelectionGrid(gLightMode, lightModes, 1, EditorStyles.radioButton);
				EditorGUILayout.BeginHorizontal();
				if(GUILayout.Button("Populate Scenes"))
				{
					if(EditorApplication.SaveCurrentSceneIfUserWantsTo())
					{
						string baseScene = EditorApplication.currentScene;
						EditorApplication.NewScene();
						EditorApplication.OpenSceneAdditive(baseScene);
						baseScene = baseScene.Replace(".unity", "");
						if(gBackup)
							EditorApplication.SaveScene(baseScene + "_backup.unity");
						EditorApplication.SaveScene(baseScene + "basisX" + ".unity");
						EditorApplication.SaveScene(baseScene + "basisY" + ".unity");
						EditorApplication.SaveScene(baseScene + "basisZ" + ".unity");
						GzRNMHelperTools.Bake(baseScene);
					}
				}
				GUILayout.FlexibleSpace();
				GUILayout.Button("Bake");
				EditorGUILayout.EndHorizontal();
			}
		}
		*/
	}
}
