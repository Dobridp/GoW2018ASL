state("GoW")
{
    //orginal address
    string100 SaveDescript : 0x22C67E0; //Location + objective in string
    int Obj : 0x22C6904; //Objective in int; Null objective = 0
    int Load : 0x22E9DB0; //0 not loading; 257/256 loading
    int Shop : 0x2448448; //0 out of the shop; 2 in the shop
    int SkapSlag : 0x0142C400, 0x0, 0x28, 0x20, 0x0, 0x40, 0x17B0; //tracks current Skap Slag
    string5 MRT : 0x01580010, 0x2A8, 0x0; //Tracks the number of odin ravens destroyed in midgard
    int ORL : 0x01425F90, 0x9AC0; //Tracks the number for the labor of odins ravens
    int MainMenu : 0x22E9DB4; //1 When in the main menu an when selecting the difficulty and 0 when your not in either of those situations

    //address for all the helmets of the Valks a lot easier than having the obj number
    int GunnrHelmet : 0x014261C0, 0x230; //-1 when u dont have the helmet 1 when u do then 0 if u plcae it on the council of the valks
    int GöndulHelmet : 0x014261C0, 0x270; //-1 when u dont have the helmet 1 when u do then 0 if u plcae it on the council of the valks
    int GeirdrifulHelmet : 0x014261C0, 0x2B0; //-1 when u dont have the helmet 1 when u do then 0 if u plcae it on the council of the valks
    int KaraHelmet : 0x014261C0, 0x2F0; //-1 when u dont have the helmet 1 when u do then 0 if u plcae it on the council of the valks
    int RòtaHelmet : 0x014261C0, 0x330; //-1 when u dont have the helmet 1 when u do then 0 if u plcae it on the council of the valks
    int EirHelmet : 0x014261C0, 0x370; //-1 when u dont have the helmet 1 when u do then 0 if u plcae it on the council of the valks
    int HildrHelmet : 0x014261C0, 0x3B0; //-1 when u dont have the helmet 1 when u do then 0 if u plcae it on the council of the valks
    int OlrunHelmet : 0x014261C0, 0x3F0; //-1 when u dont have the helmet 1 when u do then 0 if u plcae it on the council of the valks
    int SigrunHelmet : 0x014261C0, 0x430; // -1 when u dont have the helmet 1 when u do
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
    vars.Buri = 0;
}

onStart
{
    if (settings["100% NG+"])
    {
        vars.Hundo = new List<string>{
            "Toys",
            "Baldur Fight I",
            "Foothills I",
            "Realm Tear I",
            "Foothills II",
            "Mimir",
            "Volunder Mines",
            "Dragon I",
            "Horns",
            "River Pass II",
            "Chisel",
            "Realm Tear II",
            "Realm Tear III",
            "Northi Stronghold",
            "I think I broke him",
            "Helheim I",
            "Masks",
            "Landsuther Mines",
            "Realm Tear IV",
            "Dead Freight",
            "Realm Tear 5",
            "Dragon II",
            "Anatomy of Hope",
            "Realm Tear VI",
            "Hammer Fall",
            "Tyr's Vault",
            "Cups",
            "Realm Tear VII",
            "Mountain 100%",
            "Helheim Story",
            "Heirloom",
            "Realm Tear VIII",
            "Spoils of War",
            "Dragon III",
            "Realm Tear IX",
            "Konusgard Done",
            "Unfinished Buisness",
            "Ship Heads",
            "Realm Tear X",
            "Unity Stone",
            "Gauntlet of the Realms",
            "Time for Jotunheim...lol jk",
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
            "Nifelheim",
            "Hildr",
            "Ivaldi's Workshop",
            "Ivaldi's Protection",
            "Ivaldi's Curse",
            "Council",
            "Realm Tears XIII",
            "Realm Tear XIV"
        };
    }
}

start
{
    if (settings["Splits for Main Game"] && current.MainMenu == 0 && old.MainMenu == 1 && current.Load == 0){
        return true;
    }
    if (settings["Split for Valkyrie%"] && old.Shop > current.Shop){
        return true;
    }
    if (settings["100% NG+"] && current.MainMenu == 0 && old.MainMenu == 1 && current.Load == 0)
    {
        return true;
    }
}

split
{
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

    if (settings["Splits for Main Game"])
    {
        if (old.Obj != current.Obj) // Split on Obj address changing
        {
        string objTransition = old.Obj + "," + current.Obj;
        if (settings.ContainsKey(objTransition) && settings[objTransition])
            {
            vars.completedsplits.Add(objTransition);
            return true;
            }
        }
    }

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
    } else if(settings["Buri stronghold"] && current.SaveDescript == "Midgard - Shores of Nine - Return to Týr’s Vault" && old.SaveDescript == "Midgard - Buri’s Storeroom - Return to Týr’s Vault" && vars.Buri == 0)
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
    if (settings["Side Stuff"])
    {
        vars.completedsplits.Add(vars.Hundo[0]);
        vars.Hundo.RemoveAt(0);
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
}

//so i dont have to make this if statment over an over again
/*else if (settings["Side Stuff"] && current.SaveDescript == "" && old.SaveDescript == "")
    {
        vars.completed.Add(0, "");
        return true;
    }*/
