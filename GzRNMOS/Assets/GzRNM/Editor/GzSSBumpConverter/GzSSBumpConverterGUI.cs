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


public class GzSSBumpConverterGUI : ScriptableWizard
{
    public Texture2D Normal;
    public bool MadeInSSBumpGenerator;

    [MenuItem("Utilities/GzRNM/SSBump Converter")]

    static void CreateWizard()
    {
        ScriptableWizard.DisplayWizard<GzSSBumpConverterGUI>("Create SSBump");
    }

    void OnWizardCreate()
    {
        GzSSBumpConverterUtil.FlattenSSBump(Normal, MadeInSSBumpGenerator);
    }

    void OnWizardUpdate()
    {
        helpString = "Select a normal map or DirectX-style SSBump map, and click Create.";
    }
}
