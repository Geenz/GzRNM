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
using System.Collections;
using System.Text;

public class GzBasisManager : MonoBehaviour {

    static public void SetBasis(Vector3[] basis)
    {
		
        GameObject[] gameObjects = GameObject.FindObjectsOfType(typeof(GameObject)) as GameObject[];
        foreach (GameObject g in gameObjects)
        {
            if (g.renderer != null)
            {
                for (int i = 0; i < g.renderer.sharedMaterials.Length; i++)
                {
                    g.renderer.sharedMaterials[i].SetVector("_RNMBASISX", basis[0]);
                    g.renderer.sharedMaterials[i].SetVector("_RNMBASISY", basis[1]);
                    g.renderer.sharedMaterials[i].SetVector("_RNMBASISZ", basis[2]);
                }
            }
        }
		SetGlobalBasis("basisX", basis[0]);
		SetGlobalBasis("basisY", basis[1]);
		SetGlobalBasis("basisZ", basis[2]);
    }
	
	static public Vector3 GetGlobalBasis(string basisParam)
	{
		char[] delimiterChars = {','};
        IniParser config = new IniParser("Assets/GzRNM/Editor/Config/gzrnm.ini");
		string[] vecstr = config.GetSetting("BasisSettings", basisParam).Split(delimiterChars);
		return new Vector3(float.Parse(vecstr[0]), float.Parse(vecstr[1]), float.Parse(vecstr[2]));
	}
	
	static public void SetGlobalBasis(string basisParam, Vector3 basis)
	{
        IniParser config = new IniParser("Assets/GzRNM/Editor/Config/gzrnm.ini");
		config.AddSetting("BasisSettings", basisParam, basis.x.ToString() + "," + basis.y.ToString() + "," + basis.z.ToString());
		config.SaveSettings();
	}
}