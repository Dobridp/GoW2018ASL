state("GoW")
{
    //original address
    string100 SaveDescript : 0x22C67E0; //Location + objective in string
    int Obj : 0x22C6904; //Objective in int; Null objective = 0
    int Load : 0x22E9DB0; //0 not loading; 257/256 loading
    int Shop : 0x2448448; //0 out of the shop; 2 in the shop
    int MainMenu : 0x22E9DB4; //1 When in the main menu an when selecting the difficulty and 0 when your not in either of those situations
    int stunned : 0x2D460C0; // 0 for when a enemy isn't stunned 1 for when they are. Used for sigrun vh% and alfheim%
    int sword : 0x2C31DE0; //0 for when kratos is not interacting with the sword 31 when he is. Used for trials
    int combat : 0x22E77F0; //0 when not in combat and 1 for in combat. Used for trials

    // Resources, Health, and other stuff
    int SkapSlag : 0x0142C400, 0x0, 0x40, 0x17B0; //tracks current Skap Slag
    int SmolderingEmber : 0x014262C0, 0x70, 0xE70; //tracks current smoldering ember
    int Hacksilver: 0x014261C0, 0x1F0; //tracks current hacksilver
    int DragonTear: 0x014261C0, 0x4AB0; //tracks current dragon tears
    int ORL : 0x026D4778, 0x9AC0; //Tracks the number for the labor of odin's ravens
    float DarkElfKingHealth : 0x02C34138, 0x388; //tracks the EnemyHealth useful for alfheim% primarily used for the dark elf king at the end of alfheim

    //address for all the helmets of the Valks a lot easier than having the obj number
    int GunnrHelmet : 0x014261C0, 0x230; //-1 when u dont have the helmet 1 when u do then 0 if u place it on the council of the valks
    int GöndulHelmet : 0x014261C0, 0x270; //-1 when u dont have the helmet 1 when u do then 0 if u place it on the council of the valks
    int GeirdrifulHelmet : 0x014261C0, 0x2B0; //-1 when u dont have the helmet 1 when u do then 0 if u place it on the council of the valks
    int KaraHelmet : 0x014261C0, 0x2F0; //-1 when u dont have the helmet 1 when u do then 0 if u place it on the council of the valks
    int RòtaHelmet : 0x014261C0, 0x330; //-1 when u dont have the helmet 1 when u do then 0 if u place it on the council of the valks
    int EirHelmet : 0x014261C0, 0x370; //-1 when u dont have the helmet 1 when u do then 0 if u place it on the council of the valks
    int HildurHelmet : 0x014261C0, 0x3B0; //-1 when u dont have the helmet 1 when u do then 0 if u place it on the council of the valks
    int OlrunHelmet : 0x014261C0, 0x3F0; //-1 when u dont have the helmet 1 when u do then 0 if u place it on the council of the valks
    int SigrunHelmet : 0x014261C0, 0x430; // -1 when u dont have the helmet 1 when u do
    float ValkHealth : 0x02CDBBA8, 0x388; // Same as DarkElfKingHealth but this actually tracks the valkyries health. Useful for Sigrun vh%
}

startup
{
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Basic");
    var culture = System.Globalization.CultureInfo.CurrentCulture.Name;
    vars.Log(culture);

    switch (culture)
    {
        case "pt-BR":
            vars.Helper.Settings.CreateFromXml("Components/GodOfWar.Settings." + culture + ".xml");
            break;
        default:
            vars.Helper.Settings.CreateFromXml("Components/GodOfWar.Settings.en-US.xml");
            break;
    }

    vars.completedsplits = new List<string>{};
    vars.ValksDead = new List<string>{};
    vars.ObjComplete = new List<int>{};
    vars.TrialsComplete = new List<string>{};
    vars.Hundo = new List<string>{};
    vars.Buri = 0;

     // Set text component function to display pointer value as a fraction
    Action<string, string> SetTextComponent = (id, text) => {
        var textSettings = timer.Layout.Components.Where(x => x.GetType().Name == "TextComponent").Select(x => x.GetType().GetProperty("Settings").GetValue(x, null));
        var textSetting = textSettings.FirstOrDefault(x => (x.GetType().GetProperty("Text1").GetValue(x, null) as string) == id);
        if (textSetting == null)
        {
            var textComponentAssembly = Assembly.LoadFrom("Components\\LiveSplit.Text.dll");
            var textComponent = Activator.CreateInstance(textComponentAssembly.GetType("LiveSplit.UI.Components.TextComponent"), timer);
            timer.Layout.LayoutComponents.Add(new LiveSplit.UI.Components.LayoutComponent("LiveSplit.Text.dll", textComponent as LiveSplit.UI.Components.IComponent));

            textSetting = textComponent.GetType().GetProperty("Settings", BindingFlags.Instance | BindingFlags.Public).GetValue(textComponent, null);
            textSetting.GetType().GetProperty("Text1").SetValue(textSetting, id);
        }

        if (textSetting != null)
            textSetting.GetType().GetProperty("Text2").SetValue(textSetting, text);
    };
    vars.SetTextComponent = SetTextComponent;

}

update
{
    if (settings["Odin Ravens tracker"])
    {
        // Check if the ORL pointer is null
        if (current.ORL != null)
        {
            // Display ORL value as value/51, including when it's 0
            vars.SetTextComponent("Odin's Ravens Destroyed", current.ORL + "/51");
        }
        else
        {
            // Do not display anything if ORL is null (i.e., no "N/A")
            vars.SetTextComponent("Pointer invalid open game. If you open the game an you still see this then contact TpRedNinja in the speedrun discord for gow");
        }
    }

    if (settings["HackSilver"])
    {
        // Check if the Hacksilver pointer is null
        if (current.Hacksilver != null)
        {
            // Display Hacksilver value as value/99999999, including when it's 0
            vars.SetTextComponent("Hacksilver", current.Hacksilver);
        }
        else
        {
            // Do not display anything if Hacksilver is null (i.e., no "N/A")
            vars.SetTextComponent("Pointer invalid open game. If you open the game an you still see this then contact TpRedNinja in the speedrun discord for gow");
        }
    }
   
}

onStart
{
    if (settings["Trials Reg%"])
    {
        vars.TrialsComplete = new List<string>{
            "Trial I Normal",
            "Trial I Hard",
            "Trial II Normal",
            "Trial II Hard",
            "Trial III Normal",
            "Trial III Hard",
            "Trial IV Normal",
            "Trial IV Hard",
            "Trial V Normal",
            "Trial V Hard",
            "Göndul"
        };
    }else if (settings["Trials impossible%"])
    {
        vars.TrialsComplete = new List<string>{
            "Trial I Impossible",
            "Trial II Impossible",
            "Trial III Impossible",
            "Trial IV Impossible",
            "Trial V Impossible",
            "Sword"
        };
    }
}

start
{
    if ((settings["Splits for Main Game"] || settings["100% NG+"]) && current.MainMenu == 0 && old.MainMenu == 1 && current.Load == 0){
        return true;
    }
    if (settings["Split for Valkyrie%"] && old.Shop > current.Shop){
        return true;
    }
    if (settings["All Ravens"] && current.ORL == 1 && old.ORL == 0)
    {
        return true;
    }
    if ((settings["Trials Reg%"] || settings["Trials impossible%"]) && current.sword == 0 && old.sword == 31 && current.combat == 1)
    {
        return true;
    }
}

split
{
    //split for ending of alfheim%
    if (settings["Alfheim%"] && current.stunned == 0 && current.DarkElfKingHealth <= 1 && current.Obj == 3701 && !vars.completedsplits.Contains("Alfheim%")) //final split for alfheim %
    {
        vars.completedsplits.Add("Alfheim%);
        return true;
    }

     //splits for trials% ng and ng+
    if (settings["Trials Reg%"])
    {
        if (current.SmolderingEmber > old.SmolderingEmber)
        {
            return true;
        } else if (current.combat == 0 && old.combat == 1 && vars.completedsplits.Contains("Trial V Hard"));
        {
            return true;
        }
    } else if (settings["Trials impossible%"])
    {
        if (current.SmolderingEmber > old.SmolderingEmber)
        {
            return true;
        } else if (current.sword == 31 && old.sword == 0 && vars.completedsplits.Contains("Trial V Impossible"))
        {
            return true;
        }
    }

    //splits for all ravens%
    if (settings["Normal"])
    {
        if (current.ORL > old.ORL)
        {
            return true;
        }
    } else if (settings["51"])
    {
        if (current.ORL == 51 && old.ORL != 51 )
        {
            return true;
        }
    }

    //valk splits for valk%
    if (settings["Split for Valkyrie%"])
    {
        if (current.GunnrHelmet == 1 && old.GunnrHelmet == -1 && !vars.ValksDead.Contains("Gunnr")){
            vars.ValksDead.Add("Gunnr");
            return true;
        }
        if (current.KaraHelmet == 1 && old.KaraHelmet == -1 && !vars.ValksDead.Contains("Kara")){
            vars.ValksDead.Add("Kara");
            return true;
        }
        if (current.GeirdrifulHelmet == 1 && old.GeirdrifulHelmet == -1 && !vars.ValksDead.Contains("Geirdriful")){
            vars.ValksDead.Add("Geirdriful");
            return true;
        }
        if (current.EirHelmet == 1 && old.EirHelmet == -1 && !vars.ValksDead.Contains("Eir")){
            vars.ValksDead.Add("Eir");
            return true;
        }
        if (current.RòtaHelmet == 1 && old.RòtaHelmet == -1 && !vars.ValksDead.Contains("Ròta")){
            vars.ValksDead.Add("Ròta");
            return true;
        }
        if (current.OlrunHelmet == 1 && old.OlrunHelmet == -1 && !vars.ValksDead.Contains("Olrun")){
            vars.ValksDead.Add("Olrun");
            return true;
        }
        if (current.GöndulHelmet == 1 && old.GöndulHelmet == -1 && !vars.ValksDead.Contains("Göndul")){
           vars.ValksDead.Add("Göndul");
            return true;
        }
        if (current.HildrHelmet == 1 && old.HildrHelmet == -1 && !vars.ValksDead.Contains("Hildr")){
            vars.ValksDead.Add("Hildr");
            return true;
        }
    }

    //splits for ng and ng+ runs
    if (settings["Splits for Main Game"])
    {
        if (old.Obj != current.Obj) // Split on Obj address changing
        {
        string objTransition = old.Obj + "," + current.Obj;
        print("Obj Transition: " + objTransition);
        if (settings.ContainsKey(objTransition) && settings[objTransition])
            {
            vars.completedsplits.Add(objTransition);
            return true;
            }
        }
    }

    if (settings["Dragon"])
    {
        if (current.DragonTear > old.DragonTear && !vars.completedsplits.Contains("Dragon");)
        {
            vars.completedsplits.Add("Dragon");
            return true;
        }
    }

    //splits for 100% ng+
    //makes sure it doesnt split when placing the valk helmets also splits when skap slag increases by 5,9, or 18
    if (settings["Side Stuff"] && current.SkapSlag == old.SkapSlag + 9 && (current.GunnrHelmet == 0 || current.KaraHelmet == 0 || current.GeirdrifulHelmet == 0 || current.EirHelmet == 0 || current.RòtaHelmet == 0 || current.OlrunHelmet == 0 || current.GöndulHelmet == 0 || current.HildrHelmet == 0))
    {
        return false;
    } else if (settings["Valks"] && !vars.completedsplits.Contains("Hildur") && current.SkapSlag == old.SkapSlag + 9 && vars.completedsplits.Contains("Göndul") && current.GöndulHelmet == 1)
    {
        vars.completedsplits.Add("Hildur");
        return true;
    } else if (settings["Side Stuff"] && (current.SkapSlag == old.SkapSlag + 5 || current.SkapSlag == old.SkapSlag + 9 || current.SkapSlag == old.SkapSlag + 18) )
    {
        return true;
    }

    //splits when leaving certain locations on the map
    if (settings["Locations"] && current.SaveDescript == "Midgard - Veithurgard - Return to the Witch’s Cave" && old.SaveDescript == "Midgard - Stone Falls - Return to the Witch’s Cave" && !vars.completedsplits.Contains("Stone Falls I"))
    {
        vars.completedsplits.Add("Stone Falls I");
        return true;
    } else if (settings["Locations"] && current.SaveDescript == "Midgard - Ruins of the Ancient - Go to Týr’s Vault" && old.SaveDescript == "Midgard - Shores of Nine - Go to Týr’s Vault" && !vars.completedsplits.Contains("Light Elf Outpost"))
    {
        vars.completedsplits.Add("Light Elf Outpost");
        return true;
    } else if (settings["Locations"] && current.SaveDescript == "Midgard - Northri Stronghold - Go to Týr’s Vault" && old.SaveDescript == "Midgard - Ruins of the Ancient - Go to Týr’s Vault" && !vars.completedsplits.Contains("Ruins of the Ancient"))
    {
        vars.completedsplits.Add("Ruins of the Ancient");
        return true;
    }  else if (settings["Locations"] && current.SaveDescript == "Midgard - Iron Cove - Return to Týr’s Vault" && old.SaveDescript == "Midgard - Isle of Death - Return to Týr’s Vault" && !vars.completedsplits.Contains("Isle of Death"))
    {
        vars.completedsplits.Add("Isle of Death");
        return true;
    } else if (settings["Locations"] && current.SaveDescript == "Midgard - Shores of Nine - Return to Týr’s Vault" && old.SaveDescript == "Midgard - Iron Cove - Return to Týr’s Vault" && !vars.completedsplits.Contains("Iron Cove"))
    {
        vars.completedsplits.Add("Iron Cove");
        return true;
    } else if (settings["Locations"] && current.SaveDescript == "Midgard - Shores of Nine - Return to Týr’s Vault" && old.SaveDescript == "Midgard - Stone Falls - Return to Týr’s Vault" && !vars.completedsplits.Contains("Stone Falls 100%"))
    {
        vars.completedsplits.Add("Stone Falls 100%");
        return true;
    }else if (settings["Locations"] && current.SaveDescript == "Midgard - Hidden Chamber of Odin - Journey back to the mountain" && old.SaveDescript == "Midgard - Foothills - Journey back to the mountain" && !vars.completedsplits.Contains("Foothills III"))
    {
        vars.completedsplits.Add("Foothills III");
        return true;
    } else if (settings["Locations"] && current.SaveDescript == "Midgard - The Mountain - Journey back to the mountain" && old.SaveDescript == "Midgard - Foothills - Journey back to the mountain" && !vars.completedsplits.Contains("Foothills 100%"))
    {
        vars.completedsplits.Add("Foothills 100%");
        return true;
    } else if (settings["Locations"] && current.SaveDescript == "Midgard - Hidden Chamber of Odin - Find a new path up to the summit" && old.SaveDescript == "Midgard - The Mountain - Find a new path up to the summit" && !vars.completedsplits.Contains("Mountain II"))
    {
        vars.completedsplits.Add("Mountain II");
        return true;
    }

    if (settings["Buri stronghold"] && current.SaveDescript == "Midgard - Shores of Nine - Return to Týr’s Vault" && old.SaveDescript == "Midgard - Buri’s Storeroom - Return to Týr’s Vault" && vars.Buri >= 2)
    {
        vars.completedsplits.Add("Buri's Storeroom");
        return true;
    } else if(settings["Buri stronghold"] && current.SaveDescript == "Midgard - Shores of Nine - Return to Týr’s Vault" && old.SaveDescript == "Midgard - Buri’s Storeroom - Return to Týr’s Vault" && vars.Buri < 2)
    {
        vars.Buri ++;
        return false;
    }

    //Splits whenever you gain helmets
    if (settings["Valks"] && current.GunnrHelmet == 1 && old.GunnrHelmet == -1 && !vars.completedsplits.Contains("Gunnr"))
    {
        vars.completedsplits.Add("Gunnr");
        return true;
    } else if (settings["Valks"] && current.KaraHelmet == 1 && old.KaraHelmet == -1 && !vars.completedsplits.Contains("Kara"))
    {
        vars.completedsplits.Add("Kara");
        return true;
    }  else if (settings["Valks"] && current.GeirdrifulHelmet == 1 && old.GeirdrifulHelmet == -1 && !vars.completedsplits.Contains("Geirdriful"))
    {
        vars.completedsplits.Add("Geirdriful");
        return true;
    }  else if (settings["Valks"] && current.EirHelmet == 1 && old.EirHelmet == -1 && !vars.completedsplits.Contains("Eir"))
    {
        vars.completedsplits.Add("Eir");
        return true;
    } else if (settings["Valks"] && current.RòtaHelmet == 1 && old.RòtaHelmet == -1 && !vars.completedsplits.Contains("Ròta"))
    {
        vars.completedsplits.Add("Ròta");
        return true;
    } else if (settings["Valks"] && current.OlrunHelmet == 1 && old.OlrunHelmet == -1 && !vars.completedsplits.Contains("Olrun"))
    {
        vars.completedsplits.Add("Olrun");
        return true;
    } else if (settings["Valks"] && current.GöndulHelmet == 1 && old.GöndulHelmet == -1 && !vars.completedsplits.Contains("Göndul"))
    {
        vars.completedsplits.Add("Göndul");
        return true;
    } else if (settings["Valks"] && current.SigrunHelmet == 1 && old.SigrunHelmet == -1 && !vars.completedsplits.Contains("Sigrun"))
    {
        vars.completedsplits.Add("Sigrun");
        return true;
    }

    //Splits during certain story points the inserts should give you a clear idea on where that would be
    if (settings["Main Story"] && current.Obj == 678 && old.Obj == 4620)
    {
        vars.completedsplits.Add("Troll Fight");
        return true;
    } else if (settings["Main Story"] && current.Obj == 698 && old.Obj == 692)
    {
        vars.completedsplits.Add("River Pass I");
        return true;
    } else if (settings["Main Story"] && current.Obj == 734 && old.Obj == 3701)
    {
        vars.completedsplits.Add("Alfheim Story");
        return true;
    } else if (settings["Main Story"] && current.Obj == 40077 && old.Obj == 736)
    {
        vars.completedsplits.Add("Alfheim I");
        return true;
    } else if (settings["Main Story"] && current.Obj == 756 && old.Obj == 43039)
    {
        vars.completedsplits.Add("Boy is a god!");
        return true;
    } else if (settings["Main Story"] && current.Obj == 1416 && old.Obj == 760)
    {
        vars.completedsplits.Add("Tyr's Vault Puzzles");
        return true;
    } else if (settings["Main Story"] && current.Obj == 43063 && old.Obj == 1416)
    {
        vars.completedsplits.Add("Grendel Twins Fight");
        return true;
    }else if (settings["Main Story"] && current.Obj == 21391 && old.Obj == 3574)
    {
        vars.completedsplits.Add("Into the Giant Snake");
        return true;
    }  else if (settings["Main Story"] && current.Obj == 21393 && old.Obj == 21391)
    {
        vars.completedsplits.Add("Baldur II");
        return true;
    } else if (settings["Main Story"] && current.Obj == 19884 && old.Obj == 19879)
    {
        vars.completedsplits.Add("JOTANHEIM!");
        return true;
    } else if (settings["Main Story"] && current.Obj == 19891 && old.Obj == 19884)
    {
        vars.completedsplits.Add("Finish");
        return true;
    }

}

onSplit
{
    //in case someone does a undo split an in general its better to be here
    if (settings["Side Stuff"])
    {
        if (current.SkapSlag == old.SkapSlag + 5 || current.SkapSlag == old.SkapSlag + 9 || current.SkapSlag == old.SkapSlag + 18)
        {
            vars.completedsplits.Add(vars.Hundo[0]);  
            vars.Hundo.RemoveAt(0);
        }
       
    }

    //add the stuff here b/c gotta make use out of the block 
    if (settings["Trials Reg%"])
    {
        if (current.SmolderingEmber > old.SmolderingEmber)
        {
            vars.completedsplits.Add(vars.TrialsComplete[0]);  
            vars.TrialsComplete.RemoveAt(0);
        }
        if (current.combat == 0 && old.combat == 1 && vars.completedsplits.Contains("Trial V Hard"))
        {
            vars.completedsplits.Add(vars.TrialsComplete[0]);  
            vars.TrialsComplete.RemoveAt(0);
        }
    } else if (settings["Trials impossible%"])
    {
        if (current.SmolderingEmber > old.SmolderingEmber)
        {
            vars.completedsplits.Add(vars.TrialsComplete[0]);  
            vars.TrialsComplete.RemoveAt(0);
        }
        if (current.combat == 0 && old.combat == 1 && vars.completedsplits.Contains("Trial V Impossible"))
        {
            vars.completedsplits.Add(vars.TrialsComplete[0]);  
            vars.TrialsComplete.RemoveAt(0);
        }
    }
}


isLoading
{
    return (current.Load != 0);
}

onReset
{
    vars.Buri = 0;
    vars.completedsplits.Clear();
    vars.ValksDead.Clear();
    vars.ObjComplete.Clear();
    vars.Hundo.Clear();
    vars.TrialsComplete.Clear();
}

//so i dont have to make this if statment over an over again
/*else if (settings["Side Stuff"] && current.SaveDescript == "" && old.SaveDescript == "")
    {
        vars.completed.Add(0, "");
        return true;
    }*/
    
