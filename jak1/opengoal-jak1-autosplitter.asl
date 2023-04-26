state("gk") {
  // nothing to do here; we need to grab the pointers ourselves instead of hardcoding them
}

// Runs once, the only place you can add custom settings, before the process is connected to!
startup {
  // NOTE: Enable Log Output
  Action<string, bool> DebugOutput = (text, setting) => {
    if (setting) {
      print("[OpenGOAL-Jak1] " + text);
    }
  };
  vars.DebugOutput = DebugOutput;

  Action<List<Dictionary<String, dynamic>>, string, int, Type, dynamic, bool, string, bool> AddOption = (list, id, offset, type, splitVal, defaultEnabled, name, debug) => {
    var d = new Dictionary<String, dynamic>();
    d.Add("id", id);
    d.Add("offset", offset);
    d.Add("type", type);
    d.Add("splitVal", splitVal);
    d.Add("defaultEnabled", defaultEnabled);
    d.Add("name", name);
    d.Add("debug", debug);
    list.Add(d);
  };

  Action<dynamic, string> AddToSettings = (options, parent) => {
    foreach (Dictionary<String, dynamic> option in options) {
      settings.Add(option["id"], option["defaultEnabled"], option["name"], parent);
    }
  };

  settings.Add("asl_settings", true, "Autosplitter Settings");
  settings.Add("asl_settings_debug", false, "Enable Debug Logs", "asl_settings");

  // Need Resolution Splits - offset is relative from the need resolution block of the struct
  settings.Add("jak1_need_res", true, "Levels");
  var structByteIdx = 0;

  vars.optionLists = new List<List<Dictionary<String, dynamic>>>();

  // Training
  vars.trainingResolutions = new List<Dictionary<String, dynamic>>();

  AddOption(vars.trainingResolutions, "res_training_gimmie", 0, typeof(byte), 1, false, "Find the Cell on the Path", false);
  AddOption(vars.trainingResolutions, "res_training_door", 1, typeof(byte), 1, false, "Open the Precursor Door", false);
  AddOption(vars.trainingResolutions, "res_training_climb", 2, typeof(byte), 1, false, "Climb up the Cliff", false);
  AddOption(vars.trainingResolutions, "res_training_buzzer", 3, typeof(byte), 1, false, "Free 7 Scout Flies", false);
  settings.Add("jak1_need_res_training", true, "Geyser Rock", "jak1_need_res");
  AddToSettings(vars.trainingResolutions, "jak1_need_res_training");
  vars.optionLists.Add(vars.trainingResolutions);

  // Village 1
  vars.village1Resolutions = new List<Dictionary<String, dynamic>>();
  AddOption(vars.village1Resolutions, "res_village1_yakow", 12, typeof(byte), 1, false, "Herd the Yakows into their pen", false);
  AddOption(vars.village1Resolutions, "res_village1_mayor_money", 13, typeof(byte), 1, false, "Bring 90 orbs to the Mayor", false);
  AddOption(vars.village1Resolutions, "res_village1_uncle_money", 14, typeof(byte), 1, false, "Bring 90 orbs to your Uncle", false);
  AddOption(vars.village1Resolutions, "res_village1_oracle_money1", 15, typeof(byte), 1, false, "Bring 120 orbs to the Oracle", false);
  AddOption(vars.village1Resolutions, "res_village1_oracle_money2", 16, typeof(byte), 1, false, "Bring another 120 orbs to the Oracle", false);
  AddOption(vars.village1Resolutions, "res_village1_buzzer", 17, typeof(byte), 1, false, "Free 7 Scout Flies", false);
  settings.Add("jak1_need_res_village1", true, "Sandover Village", "jak1_need_res");
  AddToSettings(vars.village1Resolutions, "jak1_need_res_village1");
  vars.optionLists.Add(vars.village1Resolutions);

  // Beach
  vars.beachResolutions = new List<Dictionary<String, dynamic>>();

  AddOption(vars.beachResolutions, "res_beach_ecorocks", 18, typeof(byte), 1, false, "Unblock the eco harvesters", false);
  AddOption(vars.beachResolutions, "res_beach_pelican", 19, typeof(byte), 1, false, "Get the power cell from the pelican", false);
  AddOption(vars.beachResolutions, "res_beach_flutflut", 20, typeof(byte), 1, false, "Push the Flut Flut egg off the cliff", false);
  AddOption(vars.beachResolutions, "res_beach_seagull", 21, typeof(byte), 1, false, "Chase the seagulls", false);
  AddOption(vars.beachResolutions, "res_beach_cannon", 22, typeof(byte), 1, false, "Launch up to the cannon tower", false);
  AddOption(vars.beachResolutions, "res_beach_buzzer", 23, typeof(byte), 1, false, "Free 7 Scout Flies", false);
  AddOption(vars.beachResolutions, "res_beach_gimmie", 24, typeof(byte), 1, false, "Explore the Beach", false);
  AddOption(vars.beachResolutions, "res_beach_sentinel", 25, typeof(byte), 1, false, "Climb the Sentinel", false);
  settings.Add("jak1_need_res_beach", true, "Sentinel Beach", "jak1_need_res");
  AddToSettings(vars.beachResolutions, "jak1_need_res_beach");
  vars.optionLists.Add(vars.beachResolutions);

  // Jungle
  vars.jungleResolutions = new List<Dictionary<String, dynamic>>();
  AddOption(vars.jungleResolutions, "res_jungle_eggtop", 4, typeof(byte), 1, false, "Find the Blue Vent Switch", false);
  AddOption(vars.jungleResolutions, "res_jungle_lurkerm", 5, typeof(byte), 1, false, "Connect the Eco Beams", false);
  AddOption(vars.jungleResolutions, "res_jungle_tower", 6, typeof(byte), 1, false, "Get to the Top of the Temple", false);
  AddOption(vars.jungleResolutions, "res_jungle_fishgame", 7, typeof(byte), 1, false, "Catch 200 Pounds of Fish", false);
  AddOption(vars.jungleResolutions, "res_jungle_plant", 8, typeof(byte), 1, false, "Defeat the Dark Eco Plant", false);
  AddOption(vars.jungleResolutions, "res_jungle_buzzer", 9, typeof(byte), 1, false, "Free 7 Scout Flies", false);
  AddOption(vars.jungleResolutions, "res_jungle_canyon_end", 10, typeof(byte), 1, false, "Follow the canyon to the Sea", false);
  AddOption(vars.jungleResolutions, "res_jungle_temple_door", 11, typeof(byte), 1, false, "Open the Locked Temple Door", false);
  AddOption(vars.jungleResolutions, "int_jungle_fishgame", 107, typeof(byte), 1, false, "Talk to Fisherman", false);
  settings.Add("jak1_need_res_jungle", true, "Forbidden Jungle", "jak1_need_res");
  AddToSettings(vars.jungleResolutions, "jak1_need_res_jungle");
  vars.optionLists.Add(vars.jungleResolutions);

  // Misty
  vars.mistyResolutions = new List<Dictionary<String, dynamic>>();

  AddOption(vars.mistyResolutions, "res_misty_muse", 26, typeof(byte), 1, false, "Catch the Sculptors Muse", false);
  AddOption(vars.mistyResolutions, "res_misty_boat", 27, typeof(byte), 1, false, "Climb the Lurker Ship", false);
  AddOption(vars.mistyResolutions, "res_misty_warehouse", 28, typeof(byte), 1, false, "Return to the Dark Eco Pool", false);
  AddOption(vars.mistyResolutions, "res_misty_cannon", 29, typeof(byte), 1, false, "Stop the Cannon", false);
  AddOption(vars.mistyResolutions, "res_misty_bike", 30, typeof(byte), 1, false, "Destroy the Balloon Lurkers", false);
  AddOption(vars.mistyResolutions, "res_misty_buzzer", 31, typeof(byte), 1, false, "Free 7 Scout Flies", false);
  AddOption(vars.mistyResolutions, "res_misty_bike_jump", 32, typeof(byte), 1, false, "Use Zoomer to Reach Power Cell", false);
  AddOption(vars.mistyResolutions, "res_misty_eco_challenge", 33, typeof(byte), 1, false, "Use Blue Eco to Reach Power Cell", false);
  settings.Add("jak1_need_res_misty", true, "Misty Island", "jak1_need_res");
  AddToSettings(vars.mistyResolutions, "jak1_need_res_misty");
  vars.optionLists.Add(vars.mistyResolutions);

  // Fire Canyon
  vars.firecanyonResolutions = new List<Dictionary<String, dynamic>>();
  AddOption(vars.firecanyonResolutions, "res_firecanyon_buzzer", 74, typeof(byte), 1, false, "Free 7 Scout Flies", false);
  AddOption(vars.firecanyonResolutions, "res_firecanyon_end", 75, typeof(byte), 1, false, "Reach the End of Fire Canyon", false);
  settings.Add("jak1_need_res_firecanyon", true, "Fire Canyon", "jak1_need_res");
  AddToSettings(vars.firecanyonResolutions, "jak1_need_res_firecanyon");
  vars.optionLists.Add(vars.firecanyonResolutions);

  // Village 2
  vars.village2Resolutions = new List<Dictionary<String, dynamic>>();
  AddOption(vars.village2Resolutions, "res_village2_gambler_money", 34, typeof(byte), 1, false, "Bring 90 Orbs to the Gambler", false);
  AddOption(vars.village2Resolutions, "res_village2_geologist_money", 35, typeof(byte), 1, false, "Bring 90 Orbs to the Geologist", false);
  AddOption(vars.village2Resolutions, "res_village2_warrior_money", 36, typeof(byte), 1, false, "Bring 90 Orbs to the Warrior", false);
  AddOption(vars.village2Resolutions, "res_village2_oracle_money1", 37, typeof(byte), 1, false, "Bring 120 Orbs to the oracle", false);
  AddOption(vars.village2Resolutions, "res_village2_oracle_money2", 38, typeof(byte), 1, false, "Bring another 120 Orbs to the oracle", false);
  AddOption(vars.village2Resolutions, "res_village2_buzzer", 39, typeof(byte), 1, false, "Free 7 Scout Flies", false);
  settings.Add("jak1_need_res_village2", true, "Rock Village", "jak1_need_res");
  AddToSettings(vars.village2Resolutions, "jak1_need_res_village2");
  vars.optionLists.Add(vars.village2Resolutions);

  // Sunken
  vars.sunkenResolutions = new List<Dictionary<String, dynamic>>();
  AddOption(vars.sunkenResolutions, "res_sunken_platforms", 49, typeof(byte), 1, false, "Match the Platform Colors", false);
  AddOption(vars.sunkenResolutions, "res_sunken_pipe", 50, typeof(byte), 1, false, "Follow the Colored Pipes", false);
  AddOption(vars.sunkenResolutions, "res_sunken_slide", 51, typeof(byte), 1, false, "Reach the Bottom of the City", false);
  AddOption(vars.sunkenResolutions, "res_sunken_room", 52, typeof(byte), 1, false, "Raise the Chamber", false);
  AddOption(vars.sunkenResolutions, "res_sunken_sharks", 53, typeof(byte), 1, false, "Quickly Cross the Dangerous Pool", false);
  AddOption(vars.sunkenResolutions, "res_sunken_buzzer", 54, typeof(byte), 1, false, "Free 7 Scout Flies", false);
  AddOption(vars.sunkenResolutions, "res_sunken_top_of_helix", 55, typeof(byte), 1, false, "Climb the Slide Tube", false);
  AddOption(vars.sunkenResolutions, "res_sunken_spinning_room", 56, typeof(byte), 1, false, "Reach the Center of the Complex", false);
  settings.Add("jak1_need_res_sunken", true, "Lost Precursor City", "jak1_need_res");
  AddToSettings(vars.sunkenResolutions, "jak1_need_res_sunken");
  vars.optionLists.Add(vars.sunkenResolutions);

  // Swamp
  vars.swampResolutions = new List<Dictionary<String, dynamic>>();
  AddOption(vars.swampResolutions, "res_swamp_billy", 40, typeof(byte), 1, false, "Protect Farthy's Snacks", false);
  AddOption(vars.swampResolutions, "res_swamp_flutflut", 41, typeof(byte), 1, false, "Ride the Flut Flut", false);
  AddOption(vars.swampResolutions, "res_swamp_battle", 42, typeof(byte), 1, false, "Defeat the Lurker Ambush", false);
  AddOption(vars.swampResolutions, "res_swamp_tether_1", 43, typeof(byte), 1, false, "Break the first tether to the Zeppelin", false);
  AddOption(vars.swampResolutions, "res_swamp_tether_2", 44, typeof(byte), 1, false, "Break the second tether to the Zeppelin", false);
  AddOption(vars.swampResolutions, "res_swamp_tether_3", 45, typeof(byte), 1, false, "Break the third tether to the Zeppelin", false);
  AddOption(vars.swampResolutions, "res_swamp_tether_4", 46, typeof(byte), 1, false, "Break the fourth tether to the Zeppelin", false);
  AddOption(vars.swampResolutions, "res_swamp_buzzer", 47, typeof(byte), 1, false, "Free 7 Scout Flies", false);
  //While this is a "need res task" I think its more clear if we move it to a cutscenes category and rename this category "Power cells" Or something
  //AddOption(vars.swampResolutions, "res_swamp_arm", 48, typeof(byte), 1, false, "swamp_arm", false);
  settings.Add("jak1_need_res_swamp", true, "Boggy Swamp", "jak1_need_res");
  AddToSettings(vars.swampResolutions, "jak1_need_res_swamp");
  vars.optionLists.Add(vars.swampResolutions);

  // Rolling
  vars.rollingResolutions = new List<Dictionary<String, dynamic>>();
  AddOption(vars.rollingResolutions, "res_rolling_race", 57, typeof(byte), 1, false, "Beat Record Time on the Gorge", false);
  AddOption(vars.rollingResolutions, "res_rolling_robbers", 58, typeof(byte), 1, false, "Catch the Flying Lurkers", false);
  AddOption(vars.rollingResolutions, "res_rolling_moles", 59, typeof(byte), 1, false, "Herd the Moles into their Hole", false);
  AddOption(vars.rollingResolutions, "res_rolling_plants", 60, typeof(byte), 1, false, "Cure Dark Eco Infected Plants", false);
  AddOption(vars.rollingResolutions, "res_rolling_lake", 61, typeof(byte), 1, false, "Get the Power Cell over the Lake", false);
  AddOption(vars.rollingResolutions, "res_rolling_buzzer", 62, typeof(byte), 1, false, "Free 7 Scout Flies", false);
  AddOption(vars.rollingResolutions, "res_rolling_ring_chase_1", 63, typeof(byte), 1, false, "Navigate the Purple Precursor Rings", false);
  AddOption(vars.rollingResolutions, "res_rolling_ring_chase_2", 64, typeof(byte), 1, false, "Navigate the Blue Precursor Rings", false);
  settings.Add("jak1_need_res_rolling", true, "Precursor Basin", "jak1_need_res");
  AddToSettings(vars.rollingResolutions, "jak1_need_res_rolling");
  vars.optionLists.Add(vars.rollingResolutions);

  // Ogre Boss
  vars.ogrebossResolutons = new List<Dictionary<String, dynamic>>();
  AddOption(vars.ogrebossResolutons, "res_ogre_boss", 97, typeof(byte), 1, false, "Defeat Klaww", false);
  AddOption(vars.ogrebossResolutons, "res_ogre_end", 98, typeof(byte), 1, false, "Reach the End of the Mountain Pass", false);
  AddOption(vars.ogrebossResolutons, "res_ogre_buzzer", 99, typeof(byte), 1, false, "Free 7 Scout Flies", false);
  AddOption(vars.ogrebossResolutons, "res_ogre_secret", 100, typeof(byte), 1, false, "Find the Hidden Power Cell", false);
  settings.Add("jak1_need_res_ogreboss", true, "Mountain Pass", "jak1_need_res");
  AddToSettings(vars.ogrebossResolutons, "jak1_need_res_ogreboss");
  vars.optionLists.Add(vars.ogrebossResolutons);

  // Village 3
  vars.village3Resolutions = new List<Dictionary<String, dynamic>>();
  AddOption(vars.village3Resolutions, "res_village3_extra1", 81, typeof(byte), 1, false, "Find the Hidden Power Cell", false);
  AddOption(vars.village3Resolutions, "res_village3_buzzer", 82, typeof(byte), 1, false, "Free 7 Scout Flies", false);
  AddOption(vars.village3Resolutions, "res_village3_miner_money1", 83, typeof(byte), 1, false, "Bring 90 Orbs to the Miners once", false);
  AddOption(vars.village3Resolutions, "res_village3_miner_money2", 84, typeof(byte), 1, false, "Bring 90 Orbs to the Miners twice", false);
  AddOption(vars.village3Resolutions, "res_village3_miner_money3", 85, typeof(byte), 1, false, "Bring 90 Orbs to the Miners three times", false);
  AddOption(vars.village3Resolutions, "res_village3_miner_money4", 86, typeof(byte), 1, false, "Bring 90 Orbs to the Miners four times", false);
  AddOption(vars.village3Resolutions, "res_village3_oracle_money1", 87, typeof(byte), 1, false, "Bring 120 Orbs to the Oracle", false);
  AddOption(vars.village3Resolutions, "res_village3_oracle_money2", 88, typeof(byte), 1, false, "Bring another 120 Orbs to the Oracle", false);
  settings.Add("jak1_need_res_village3", true, "Volcanic Crater", "jak1_need_res");
  AddToSettings(vars.village3Resolutions, "jak1_need_res_village3");
  vars.optionLists.Add(vars.village3Resolutions);

  // Snowy
  vars.snowyResolutions = new List<Dictionary<String, dynamic>>();
  AddOption(vars.snowyResolutions, "res_snow_eggtop", 65, typeof(byte), 1, false, "Find the Yellow Vent switch", false);
  AddOption(vars.snowyResolutions, "res_snow_ram", 66, typeof(byte), 1, false, "Stop the 3 Lurker Glacier Troops", false);
  AddOption(vars.snowyResolutions, "res_snow_fort", 67, typeof(byte), 1, false, "Get through the Lurker Fort", false);
  AddOption(vars.snowyResolutions, "res_snow_ball", 68, typeof(byte), 1, false, "Open the Lurker Fort Gate", false);
  AddOption(vars.snowyResolutions, "res_snow_bunnies", 69, typeof(byte), 1, false, "Survive the Lurker Infested Cave", false);
  AddOption(vars.snowyResolutions, "res_snow_buzzer", 70, typeof(byte), 1, false, "Free 7 Scout Flies", false);
  AddOption(vars.snowyResolutions, "res_snow_bumpers", 71, typeof(byte), 1, false, "Deactivate the Precursor Blockers", false);
  AddOption(vars.snowyResolutions, "res_snow_cage", 72, typeof(byte), 1, false, "Opent the Frozen Crate", false);
  //The task below is unsed in retail versions of the game.
  //AddOption(vars.snowyResolutions, "res_red_eggtop", 73, typeof(byte), 1, false, "red_eggtop", false);
  settings.Add("jak1_need_res_snowy", true, "Snowy Mountain", "jak1_need_res");
  AddToSettings(vars.snowyResolutions, "jak1_need_res_snowy");
  vars.optionLists.Add(vars.snowyResolutions);

  // Spider Cave
  vars.spiderCaveResolutions = new List<Dictionary<String, dynamic>>();
  AddOption(vars.spiderCaveResolutions, "res_cave_gnawers", 89, typeof(byte), 1, false, "Use your Goggles to shoot the Gnawing Lurkers", false);
  AddOption(vars.spiderCaveResolutions, "res_cave_dark_crystals", 90, typeof(byte), 1, false, "Destroy the dark Eco Crystals", false);
  AddOption(vars.spiderCaveResolutions, "res_cave_dark_climb", 91, typeof(byte), 1, false, "Explore the Dark Cave", false);
  AddOption(vars.spiderCaveResolutions, "res_cave_robot_climb", 92, typeof(byte), 1, false, "Climb the giant robot", false);
  AddOption(vars.spiderCaveResolutions, "res_cave_swing_poles", 93, typeof(byte), 1, false, "Launch to the Poles", false);
  AddOption(vars.spiderCaveResolutions, "res_cave_spider_tunnel", 94, typeof(byte), 1, false, "Navigate the Spider Tunnel", false);
  AddOption(vars.spiderCaveResolutions, "res_cave_platforms", 95, typeof(byte), 1, false, "Climb the Precursor Platforms", false);
  AddOption(vars.spiderCaveResolutions, "res_cave_buzzer", 96, typeof(byte), 1, false, "Free 7 Scout Flies", false);
  settings.Add("jak1_need_res_spidercave", true, "Spider Cave", "jak1_need_res");
  AddToSettings(vars.spiderCaveResolutions, "jak1_need_res_spidercave");
  vars.optionLists.Add(vars.spiderCaveResolutions);


  // Lava Tube
  vars.lavatubeResolutions = new List<Dictionary<String, dynamic>>();
  AddOption(vars.lavatubeResolutions, "res_lavatube_end", 101, typeof(byte), 1, false, "Reach the end of the Lava Tube", false);
  AddOption(vars.lavatubeResolutions, "res_lavatube_buzzer", 102, typeof(byte), 1, false, "Free 7 Scout Flies", false);
  //This task below does not go with a in game Power Cell
  AddOption(vars.lavatubeResolutions, "res_lavatube_balls", 103, typeof(byte), 1, false, "Finish Oranges", false);
  settings.Add("jak1_need_res_lavatube", true, "Lava Tube", "jak1_need_res");
  AddToSettings(vars.lavatubeResolutions, "jak1_need_res_lavatube");
  vars.optionLists.Add(vars.lavatubeResolutions);

  // Citadel
  vars.citadelResolutions = new List<Dictionary<String, dynamic>>();
  AddOption(vars.citadelResolutions, "res_citadel_sage_green", 76, typeof(byte), 1, false, "Free the Green Sage", false);
  AddOption(vars.citadelResolutions, "res_citadel_sage_blue", 77, typeof(byte), 1, false, "Free the Blue Sage", false);
  AddOption(vars.citadelResolutions, "res_citadel_sage_red", 78, typeof(byte), 1, false, "Free the Red Sage", false);
  AddOption(vars.citadelResolutions, "res_citadel_sage_yellow", 79, typeof(byte), 1, false, "Free the Yellow Sage", false);
  AddOption(vars.citadelResolutions, "res_citadel_buzzer", 80, typeof(byte), 1, false, "Free 7 Scout Flies", false);
  AddOption(vars.citadelResolutions, "unk_finalboss_movies", 106, typeof(byte), 1, false, "Light Eco?!?! That could be the stuff to change me back!", false);
  settings.Add("jak1_need_res_citadel", true, "Gol and Maia's Citadel", "jak1_need_res");
  AddToSettings(vars.citadelResolutions, "jak1_need_res_citadel");
  vars.optionLists.Add(vars.citadelResolutions);

  // NOTE - skipping `need_res_intro` because it's skipped when starting a run anyway

  // Misc Tasks
  // - other tasks other than `need_resolution` ones, the ones deemed useful enough to be added
  settings.Add("jak1_misc_tasks", true, "Final Task");
  vars.miscallenousTasks = new List<Dictionary<String, dynamic>>();
  AddOption(vars.miscallenousTasks, "int_finalboss_movies", 105, typeof(byte), 1, true, "Collect Light Eco", false);
  AddToSettings(vars.miscallenousTasks, "jak1_misc_tasks");
  vars.optionLists.Add(vars.miscallenousTasks);

  // Treat this one as special, so we can ensure the timer ends no matter what!
  vars.finalSplitTask = vars.miscallenousTasks[0];

  vars.DebugOutput("Finished {startup}", true);
}

init {
  vars.DebugOutput("Running {init} looking for `gk.exe`", true);
  var sw = new Stopwatch();
  sw.Start();
  var exported_ptr = IntPtr.Zero;
  vars.foundPointers = false;
  byte[] marker = Encoding.ASCII.GetBytes("UnLiStEdStRaTs_JaK1" + Char.MinValue);
  vars.debugTick = 0;
  vars.DebugOutput(String.Format("Base Addr - {0}", modules.First().BaseAddress.ToString("x8")), true);
  exported_ptr = new SignatureScanner(game, modules.First().BaseAddress, modules.First().ModuleMemorySize).Scan(
    new SigScanTarget(marker.Length, marker)
  );

  if (exported_ptr == IntPtr.Zero) {
    vars.DebugOutput("Could not find the AutoSplittingInfo struct, old version of gk.exe? Failing!", true);
    sw.Reset();
    return false;
  }
  vars.DebugOutput(String.Format("Found AutoSplittingInfo struct - {0}", exported_ptr.ToString("x8")), true);

  // The offset to the GOAL struct is stored in a u64 next to the marker!
  var goal_struct_ptr = new IntPtr(memory.ReadValue<long>(exported_ptr + 4));
  while (goal_struct_ptr == IntPtr.Zero) {
    vars.DebugOutput("Could not find pointer to GOAL struct, game still loading? Retrying in 1000ms...!", true);
    Thread.Sleep(1000);
    sw.Reset();
    throw new Exception("Could not find pointer to GOAL struct, game still loading? Retrying...");
  }
  Action<MemoryWatcherList, IntPtr, List<Dictionary<String, dynamic>>> AddMemoryWatchers = (memList, bPtr, options) => {
    foreach (Dictionary<String, dynamic> option in options) {
      var finalOffset = bPtr + (option["offset"]);
      // TODO - use the type on the object to make this value properly.  Right now everything is a u8
      memList.Add(new MemoryWatcher<byte>(finalOffset) { Name = option["id"] });
      if (option["debug"] == true) {
        memList[option["id"]].Update(game);
        vars.DebugOutput(String.Format("Debug ({0}) -> ptr [{1}]; val [{2}]", option["id"], finalOffset.ToString("x8"), memList[option["id"]].Current), true);
      }
    }
  };

  var watchers = new MemoryWatcherList{
    new MemoryWatcher<uint>(goal_struct_ptr + 212) { Name = "currentGameHash" }
  };

  // Init current game has in case script is loaded while game is already started
  watchers["currentGameHash"].Update(game);

  var jak1_need_res_bptr = goal_struct_ptr + 424; // bytes
  foreach (List<Dictionary<String, dynamic>> optionList in vars.optionLists) {
    AddMemoryWatchers(watchers, jak1_need_res_bptr, optionList);
  }
  vars.foundPointers = true;
  vars.watchers = watchers;
  sw.Stop();
  vars.DebugOutput("Script Initialized, Game Compatible.", true);
  vars.DebugOutput(String.Format("Found the exported struct at {0}", goal_struct_ptr.ToString("x8")), true);
  vars.DebugOutput(String.Format("It took {0} ms", sw.ElapsedMilliseconds), true);
}

update {
  if (!vars.foundPointers) {
    return false;
  }

  vars.watchers.UpdateAll(game);
}

reset {
  if (vars.watchers["currentGameHash"].Current != 0 && vars.watchers["currentGameHash"].Current != vars.watchers["currentGameHash"].Old) {
    vars.DebugOutput("Resetting!", settings["asl_settings_debug"]);
    vars.DebugOutput(String.Format("Reset -> Old: {0}, Curr: {1}", vars.watchers["currentGameHash"].Old, vars.watchers["currentGameHash"].Current), settings["asl_settings_debug"]);
    return true;
  }
  return false;
}

start {
  if (vars.watchers["currentGameHash"].Current != 0 && vars.watchers["currentGameHash"].Current != vars.watchers["currentGameHash"].Old) {
    vars.DebugOutput("Starting!", settings["asl_settings_debug"]);
    vars.DebugOutput(String.Format("Start -> Old: {0}, Curr: {1}", vars.watchers["currentGameHash"].Old, vars.watchers["currentGameHash"].Current), settings["asl_settings_debug"]);
    return true;
  }
  return false;
}

isLoading {
  // todo
  return false;
}

split {
  Func<List<Dictionary<String, dynamic>>, bool> InspectValues = (list) => {
    var debugThisIter = false;
    if (vars.debugTick++ % 60 == 0) {
      debugThisIter = true;
    }
    foreach (Dictionary<String, dynamic> option in list) {
      var watcher = vars.watchers[option["id"]];
      if (option["debug"] && debugThisIter) {
        vars.DebugOutput(String.Format("Debug ({0}) -> old [{1}]; current [{2}]", option["id"], watcher.Old, watcher.Current), settings["asl_settings_debug"]);
      }
      if (settings[option["id"]]) {
        // if we don't care about the amount, split on any change
        if (option["splitVal"] == null && watcher.Current != watcher.Old) {
          return true;
        }
        // Else, make sure we've hit that goal amount
        else if (option["splitVal"] != null && watcher.Current != watcher.Old && watcher.Current == option["splitVal"]) {
          return true;
        }
      }
    }
    return false;
  };
  foreach (List<Dictionary<String, dynamic>> optionList in vars.optionLists) {
    if (InspectValues(optionList)) {
      return true;
    }
  }

  // ALWAYS split if the final split condition is true, so no matter what we exhaust all splits until the end
  if (vars.watchers[vars.finalSplitTask["id"]].Current == vars.finalSplitTask["splitVal"]) {
    return true;
  }
}
