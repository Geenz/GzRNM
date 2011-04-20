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

public class GzRNMHelperTools : Editor {

	public static void Bake(string scene)
	{
		if(EditorApplication.OpenScene(scene + "basisX.unity"))
		{
			SceneWork();
		}
	}
	
	public static void SceneWork()
	{
		BotchNormals();
	}
	
	public static void BotchNormals()
	{
		GameObject[] gameObjects = GameObject.FindObjectsOfType(typeof(GameObject)) as GameObject[];
		foreach(GameObject g in gameObjects)
		{
			if(g.isStatic)
			{
				Mesh tmpMesh = g.GetComponent<MeshFilter>().mesh;
			}
		}
	}
}
