state("gk") {
  // nothing to do here; we need to grab the pointers ourselves instead of hardcoding them
}

// Runs once, the only place you can add custom settings, before the process is connected to!
startup {
  // NOTE: Enable Log Output
  var DebugEnabled = false;
  Action<string> DebugOutput = (text) => {
      if (DebugEnabled) {
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

  // Need Resolution Splits - offset is relative from the need resolution block of the struct
  settings.Add("jak1_need_res", true, "Need Resolution");
  var structByteIdx = 0;

  vars.optionLists = new List<List<Dictionary<String, dynamic>>>();

  // Training
  vars.trainingResolutions = new List<Dictionary<String, dynamic>>();
  AddOption(vars.trainingResolutions, "res_training_gimmie", structByteIdx++, typeof(byte), 1, false, "training_gimmie", false);
  AddOption(vars.trainingResolutions, "res_training_door", structByteIdx++, typeof(byte), 1, false, "training_door", false);
  AddOption(vars.trainingResolutions, "res_training_climb", structByteIdx++, typeof(byte), 1, false, "training_climb", false);
  AddOption(vars.trainingResolutions, "res_training_buzzer", structByteIdx++, typeof(byte), 1, false, "training_buzzer", false);
  settings.Add("jak1_need_res_training", true, "Training", "jak1_need_res");
  AddToSettings(vars.trainingResolutions, "jak1_need_res_training");
  vars.optionLists.Add(vars.trainingResolutions);

  // Jungle
  vars.jungleResolutions = new List<Dictionary<String, dynamic>>();
  AddOption(vars.jungleResolutions, "res_jungle_eggtop", structByteIdx++, typeof(byte), 1, false, "jungle_eggtop", false);
  AddOption(vars.jungleResolutions, "res_jungle_lurkerm", structByteIdx++, typeof(byte), 1, false, "res_jungle_lurkerm", false);
  AddOption(vars.jungleResolutions, "res_jungle_tower", structByteIdx++, typeof(byte), 1, false, "res_jungle_tower", false);
  AddOption(vars.jungleResolutions, "res_jungle_fishgame", structByteIdx++, typeof(byte), 1, false, "res_jungle_fishgame", false);
  AddOption(vars.jungleResolutions, "res_jungle_plant", structByteIdx++, typeof(byte), 1, false, "res_jungle_plant", false);
  AddOption(vars.jungleResolutions, "res_jungle_buzzer", structByteIdx++, typeof(byte), 1, false, "res_jungle_buzzer", false);
  AddOption(vars.jungleResolutions, "res_jungle_canyon_end", structByteIdx++, typeof(byte), 1, false, "res_jungle_canyon_end", false);
  AddOption(vars.jungleResolutions, "res_jungle_temple_door", structByteIdx++, typeof(byte), 1, false, "res_jungle_temple_door", false);
  settings.Add("jak1_need_res_jungle", true, "Jungle", "jak1_need_res");
  AddToSettings(vars.jungleResolutions, "jak1_need_res_jungle");
  vars.optionLists.Add(vars.jungleResolutions);

  // Village 1
  vars.village1Resolutions = new List<Dictionary<String, dynamic>>();
  AddOption(vars.village1Resolutions, "res_village1_yakow", structByteIdx++, typeof(byte), 1, false, "village1_yakow", false);
  AddOption(vars.village1Resolutions, "res_village1_mayor_money", structByteIdx++, typeof(byte), 1, false, "village1_mayor_money", false);
  AddOption(vars.village1Resolutions, "res_village1_uncle_money", structByteIdx++, typeof(byte), 1, false, "village1_uncle_money", false);
  AddOption(vars.village1Resolutions, "res_village1_oracle_money1", structByteIdx++, typeof(byte), 1, false, "village1_oracle_money1", false);
  AddOption(vars.village1Resolutions, "res_village1_oracle_money2", structByteIdx++, typeof(byte), 1, false, "village1_oracle_money2", false);
  AddOption(vars.village1Resolutions, "res_village1_buzzer", structByteIdx++, typeof(byte), 1, false, "village1_buzzer", false);
  settings.Add("jak1_need_res_village1", true, "Village 1", "jak1_need_res");
  AddToSettings(vars.village1Resolutions, "jak1_need_res_village1");
  vars.optionLists.Add(vars.village1Resolutions);

  // Beach
  vars.beachResolutions = new List<Dictionary<String, dynamic>>();
  AddOption(vars.beachResolutions, "res_beach_ecorocks", structByteIdx++, typeof(byte), 1, false, "beach_ecorocks", false);
  AddOption(vars.beachResolutions, "res_beach_pelican", structByteIdx++, typeof(byte), 1, false, "beach_pelican", false);
  AddOption(vars.beachResolutions, "res_beach_flutflut", structByteIdx++, typeof(byte), 1, false, "beach_flutflut", false);
  AddOption(vars.beachResolutions, "res_beach_seagull", structByteIdx++, typeof(byte), 1, false, "beach_seagull", false);
  AddOption(vars.beachResolutions, "res_beach_cannon", structByteIdx++, typeof(byte), 1, false, "beach_cannon", false);
  AddOption(vars.beachResolutions, "res_beach_buzzer", structByteIdx++, typeof(byte), 1, false, "beach_buzzer", false);
  AddOption(vars.beachResolutions, "res_beach_gimmie", structByteIdx++, typeof(byte), 1, false, "beach_gimmie", false);
  AddOption(vars.beachResolutions, "res_beach_sentinel", structByteIdx++, typeof(byte), 1, false, "beach_sentinel", false);
  settings.Add("jak1_need_res_beach", true, "Beach", "jak1_need_res");
  AddToSettings(vars.beachResolutions, "jak1_need_res_beach");
  vars.optionLists.Add(vars.beachResolutions);

  // Misty
  vars.mistyResolutions = new List<Dictionary<String, dynamic>>();
  AddOption(vars.mistyResolutions, "res_misty_muse", structByteIdx++, typeof(byte), 1, false, "misty_muse", false);
  AddOption(vars.mistyResolutions, "res_misty_boat", structByteIdx++, typeof(byte), 1, false, "misty_boat", false);
  AddOption(vars.mistyResolutions, "res_misty_warehouse", structByteIdx++, typeof(byte), 1, false, "misty_warehouse", false);
  AddOption(vars.mistyResolutions, "res_misty_cannon", structByteIdx++, typeof(byte), 1, false, "misty_cannon", false);
  AddOption(vars.mistyResolutions, "res_misty_bike", structByteIdx++, typeof(byte), 1, false, "misty_bike", false);
  AddOption(vars.mistyResolutions, "res_misty_buzzer", structByteIdx++, typeof(byte), 1, false, "misty_buzzer", false);
  AddOption(vars.mistyResolutions, "res_misty_bike_jump", structByteIdx++, typeof(byte), 1, false, "misty_bike_jump", false);
  AddOption(vars.mistyResolutions, "res_misty_eco_challenge", structByteIdx++, typeof(byte), 1, false, "misty_eco_challenge", false);
  settings.Add("jak1_need_res_misty", true, "Misty", "jak1_need_res");
  AddToSettings(vars.mistyResolutions, "jak1_need_res_misty");
  vars.optionLists.Add(vars.mistyResolutions);

  // Village 2
  vars.village2Resolutions = new List<Dictionary<String, dynamic>>();
  AddOption(vars.village2Resolutions, "res_village2_gambler_money", structByteIdx++, typeof(byte), 1, false, "village2_gambler_money", false);
  AddOption(vars.village2Resolutions, "res_village2_geologist_money", structByteIdx++, typeof(byte), 1, false, "village2_geologist_money", false);
  AddOption(vars.village2Resolutions, "res_village2_warrior_money", structByteIdx++, typeof(byte), 1, false, "village2_warrior_money", false);
  AddOption(vars.village2Resolutions, "res_village2_oracle_money1", structByteIdx++, typeof(byte), 1, false, "village2_oracle_money1", false);
  AddOption(vars.village2Resolutions, "res_village2_oracle_money2", structByteIdx++, typeof(byte), 1, false, "village2_oracle_money2", false);
  AddOption(vars.village2Resolutions, "res_village2_buzzer", structByteIdx++, typeof(byte), 1, false, "village2_buzzer", false);
  settings.Add("jak1_need_res_village2", true, "Village 2", "jak1_need_res");
  AddToSettings(vars.village2Resolutions, "jak1_need_res_village2");
  vars.optionLists.Add(vars.village2Resolutions);

  // Swamp
  vars.swampResolutions = new List<Dictionary<String, dynamic>>();
  AddOption(vars.swampResolutions, "res_swamp_billy", structByteIdx++, typeof(byte), 1, false, "swamp_billy", false);
  AddOption(vars.swampResolutions, "res_swamp_flutflut", structByteIdx++, typeof(byte), 1, false, "swamp_flutflut", false);
  AddOption(vars.swampResolutions, "res_swamp_battle", structByteIdx++, typeof(byte), 1, false, "swamp_battle", false);
  AddOption(vars.swampResolutions, "res_swamp_tether_1", structByteIdx++, typeof(byte), 1, false, "swamp_tether_1", false);
  AddOption(vars.swampResolutions, "res_swamp_tether_2", structByteIdx++, typeof(byte), 1, false, "swamp_tether_2", false);
  AddOption(vars.swampResolutions, "res_swamp_tether_3", structByteIdx++, typeof(byte), 1, false, "swamp_tether_3", false);
  AddOption(vars.swampResolutions, "res_swamp_tether_4", structByteIdx++, typeof(byte), 1, false, "swamp_tether_4", false);
  AddOption(vars.swampResolutions, "res_swamp_buzzer", structByteIdx++, typeof(byte), 1, false, "swamp_buzzer", false);
  AddOption(vars.swampResolutions, "res_swamp_arm", structByteIdx++, typeof(byte), 1, false, "swamp_arm", false);
  settings.Add("jak1_need_res_swamp", true, "Swamp", "jak1_need_res");
  AddToSettings(vars.swampResolutions, "jak1_need_res_swamp");
  vars.optionLists.Add(vars.swampResolutions);

  // Sunken
  vars.sunkenResolutions = new List<Dictionary<String, dynamic>>();
  AddOption(vars.sunkenResolutions, "res_sunken_platforms", structByteIdx++, typeof(byte), 1, false, "sunken_platforms", false);
  AddOption(vars.sunkenResolutions, "res_sunken_pipe", structByteIdx++, typeof(byte), 1, false, "sunken_pipe", false);
  AddOption(vars.sunkenResolutions, "res_sunken_slide", structByteIdx++, typeof(byte), 1, false, "sunken_slide", false);
  AddOption(vars.sunkenResolutions, "res_sunken_room", structByteIdx++, typeof(byte), 1, false, "sunken_room", false);
  AddOption(vars.sunkenResolutions, "res_sunken_sharks", structByteIdx++, typeof(byte), 1, false, "sunken_sharks", false);
  AddOption(vars.sunkenResolutions, "res_sunken_buzzer", structByteIdx++, typeof(byte), 1, false, "sunken_buzzer", false);
  AddOption(vars.sunkenResolutions, "res_sunken_top_of_helix", structByteIdx++, typeof(byte), 1, false, "sunken_top_of_helix", false);
  AddOption(vars.sunkenResolutions, "res_sunken_spinning_room", structByteIdx++, typeof(byte), 1, false, "sunken_spinning_room", false);
  settings.Add("jak1_need_res_sunken", true, "Sunken", "jak1_need_res");
  AddToSettings(vars.sunkenResolutions, "jak1_need_res_sunken");
  vars.optionLists.Add(vars.sunkenResolutions);

  // Rolling
  vars.rollingResolutions = new List<Dictionary<String, dynamic>>();
  AddOption(vars.rollingResolutions, "res_rolling_race", structByteIdx++, typeof(byte), 1, false, "rolling_race", false);
  AddOption(vars.rollingResolutions, "res_rolling_robbers", structByteIdx++, typeof(byte), 1, false, "rolling_robbers", false);
  AddOption(vars.rollingResolutions, "res_rolling_moles", structByteIdx++, typeof(byte), 1, false, "rolling_moles", false);
  AddOption(vars.rollingResolutions, "res_rolling_plants", structByteIdx++, typeof(byte), 1, false, "rolling_plants", false);
  AddOption(vars.rollingResolutions, "res_rolling_lake", structByteIdx++, typeof(byte), 1, false, "rolling_lake", false);
  AddOption(vars.rollingResolutions, "res_rolling_buzzer", structByteIdx++, typeof(byte), 1, false, "rolling_buzzer", false);
  AddOption(vars.rollingResolutions, "res_rolling_ring_chase_1", structByteIdx++, typeof(byte), 1, false, "rolling_ring_chase_1", false);
  AddOption(vars.rollingResolutions, "res_rolling_ring_chase_2", structByteIdx++, typeof(byte), 1, false, "rolling_ring_chase_2", false);
  settings.Add("jak1_need_res_rolling", true, "Rolling", "jak1_need_res");
  AddToSettings(vars.rollingResolutions, "jak1_need_res_rolling");
  vars.optionLists.Add(vars.rollingResolutions);

  // Snowy
  vars.snowyResolutions = new List<Dictionary<String, dynamic>>();
  AddOption(vars.snowyResolutions, "res_snow_eggtop", structByteIdx++, typeof(byte), 1, false, "snow_eggtop", false);
  AddOption(vars.snowyResolutions, "res_snow_ram", structByteIdx++, typeof(byte), 1, false, "snow_ram", false);
  AddOption(vars.snowyResolutions, "res_snow_fort", structByteIdx++, typeof(byte), 1, false, "snow_fort", false);
  AddOption(vars.snowyResolutions, "res_snow_ball", structByteIdx++, typeof(byte), 1, false, "snow_ball", false);
  AddOption(vars.snowyResolutions, "res_snow_bunnies", structByteIdx++, typeof(byte), 1, false, "snow_bunnies", false);
  AddOption(vars.snowyResolutions, "res_snow_buzzer", structByteIdx++, typeof(byte), 1, false, "snow_buzzer", false);
  AddOption(vars.snowyResolutions, "res_snow_bumpers", structByteIdx++, typeof(byte), 1, false, "snow_bumpers", false);
  AddOption(vars.snowyResolutions, "res_snow_cage", structByteIdx++, typeof(byte), 1, false, "snow_cage", false);
  AddOption(vars.snowyResolutions, "res_red_eggtop", structByteIdx++, typeof(byte), 1, false, "red_eggtop", false);
  settings.Add("jak1_need_res_snowy", true, "Snowy Mountain", "jak1_need_res");
  AddToSettings(vars.snowyResolutions, "jak1_need_res_snowy");
  vars.optionLists.Add(vars.snowyResolutions);

  // Fire Canyon
  vars.firecanyonResolutions = new List<Dictionary<String, dynamic>>();
  AddOption(vars.firecanyonResolutions, "res_firecanyon_buzzer", structByteIdx++, typeof(byte), 1, false, "firecanyon_buzzer", false);
  AddOption(vars.firecanyonResolutions, "res_firecanyon_end", structByteIdx++, typeof(byte), 1, false, "firecanyon_end", false);
  settings.Add("jak1_need_res_firecanyon", true, "Fire Canyon", "jak1_need_res");
  AddToSettings(vars.firecanyonResolutions, "jak1_need_res_firecanyon");
  vars.optionLists.Add(vars.firecanyonResolutions);

  // Citadel
  vars.citadelResolutions = new List<Dictionary<String, dynamic>>();
  AddOption(vars.citadelResolutions, "res_citadel_sage_green", structByteIdx++, typeof(byte), 1, false, "citadel_sage_green", false);
  AddOption(vars.citadelResolutions, "res_citadel_sage_blue", structByteIdx++, typeof(byte), 1, false, "citadel_sage_blue", false);
  AddOption(vars.citadelResolutions, "res_citadel_sage_red", structByteIdx++, typeof(byte), 1, false, "citadel_sage_red", false);
  AddOption(vars.citadelResolutions, "res_citadel_sage_yellow", structByteIdx++, typeof(byte), 1, false, "citadel_sage_yellow", false);
  AddOption(vars.citadelResolutions, "res_citadel_buzzer", structByteIdx++, typeof(byte), 1, false, "citadel_buzzer", false);
  settings.Add("jak1_need_res_citadel", true, "Citadel", "jak1_need_res");
  AddToSettings(vars.citadelResolutions, "jak1_need_res_citadel");
  vars.optionLists.Add(vars.citadelResolutions);

  // Village 3
  vars.village3Resolutions = new List<Dictionary<String, dynamic>>();
  AddOption(vars.village3Resolutions, "res_village3_extra1", structByteIdx++, typeof(byte), 1, false, "village3_extra1", false);
  AddOption(vars.village3Resolutions, "res_village3_buzzer", structByteIdx++, typeof(byte), 1, false, "village3_buzzer", false);
  AddOption(vars.village3Resolutions, "res_village3_miner_money1", structByteIdx++, typeof(byte), 1, false, "village3_miner_money1", false);
  AddOption(vars.village3Resolutions, "res_village3_miner_money2", structByteIdx++, typeof(byte), 1, false, "village3_miner_money2", false);
  AddOption(vars.village3Resolutions, "res_village3_miner_money3", structByteIdx++, typeof(byte), 1, false, "village3_miner_money3", false);
  AddOption(vars.village3Resolutions, "res_village3_miner_money4", structByteIdx++, typeof(byte), 1, false, "village3_miner_money4", false);
  AddOption(vars.village3Resolutions, "res_village3_oracle_money1", structByteIdx++, typeof(byte), 1, false, "village3_oracle_money1", false);
  AddOption(vars.village3Resolutions, "res_village3_oracle_money2", structByteIdx++, typeof(byte), 1, false, "village3_oracle_money2", false);
  settings.Add("jak1_need_res_village3", true, "Village 3", "jak1_need_res");
  AddToSettings(vars.village3Resolutions, "jak1_need_res_village3");
  vars.optionLists.Add(vars.village3Resolutions);

  // Spider Cave
  vars.spiderCaveResolutions = new List<Dictionary<String, dynamic>>();
  AddOption(vars.spiderCaveResolutions, "res_cave_gnawers", structByteIdx++, typeof(byte), 1, false, "cave_gnawers", false);
  AddOption(vars.spiderCaveResolutions, "res_cave_dark_crystals", structByteIdx++, typeof(byte), 1, false, "cave_dark_crystals", false);
  AddOption(vars.spiderCaveResolutions, "res_cave_dark_climb", structByteIdx++, typeof(byte), 1, false, "cave_dark_climb", false);
  AddOption(vars.spiderCaveResolutions, "res_cave_robot_climb", structByteIdx++, typeof(byte), 1, false, "cave_robot_climb", false);
  AddOption(vars.spiderCaveResolutions, "res_cave_swing_poles", structByteIdx++, typeof(byte), 1, false, "cave_swing_poles", false);
  AddOption(vars.spiderCaveResolutions, "res_cave_spider_tunnel", structByteIdx++, typeof(byte), 1, false, "cave_spider_tunnel", false);
  AddOption(vars.spiderCaveResolutions, "res_cave_platforms", structByteIdx++, typeof(byte), 1, false, "cave_platforms", false);
  AddOption(vars.spiderCaveResolutions, "res_cave_buzzer", structByteIdx++, typeof(byte), 1, false, "cave_buzzer", false);
  settings.Add("jak1_need_res_spidercave", true, "Spider Cave", "jak1_need_res");
  AddToSettings(vars.spiderCaveResolutions, "jak1_need_res_spidercave");
  vars.optionLists.Add(vars.spiderCaveResolutions);

  // Ogre Boss
  vars.ogrebossResolutons = new List<Dictionary<String, dynamic>>();
  AddOption(vars.ogrebossResolutons, "res_ogre_boss", structByteIdx++, typeof(byte), 1, false, "ogre_boss", false);
  AddOption(vars.ogrebossResolutons, "res_ogre_end", structByteIdx++, typeof(byte), 1, false, "ogre_end", false);
  AddOption(vars.ogrebossResolutons, "res_ogre_buzzer", structByteIdx++, typeof(byte), 1, false, "ogre_buzzer", false);
  AddOption(vars.ogrebossResolutons, "res_ogre_secret", structByteIdx++, typeof(byte), 1, false, "ogre_secret", false);
  settings.Add("jak1_need_res_ogreboss", true, "Ogre Boss", "jak1_need_res");
  AddToSettings(vars.ogrebossResolutons, "jak1_need_res_ogreboss");
  vars.optionLists.Add(vars.ogrebossResolutons);

  // Lava Tube
  vars.lavatubeResolutions = new List<Dictionary<String, dynamic>>();
  AddOption(vars.lavatubeResolutions, "res_lavatube_end", structByteIdx++, typeof(byte), 1, false, "lavatube_end", false);
  AddOption(vars.lavatubeResolutions, "res_lavatube_buzzer", structByteIdx++, typeof(byte), 1, false, "lavatube_buzzer", false);
  AddOption(vars.lavatubeResolutions, "res_lavatube_balls", structByteIdx++, typeof(byte), 1, false, "lavatube_balls", false);
  settings.Add("jak1_need_res_lavatube", true, "Lava Tube", "jak1_need_res");
  AddToSettings(vars.lavatubeResolutions, "jak1_need_res_lavatube");
  vars.optionLists.Add(vars.lavatubeResolutions);

  // NOTE - skipping `need_res_intro` because it's skipped when starting a run anyway
  structByteIdx++;

  // Misc Tasks
  // - other tasks other than `need_resolution` ones, the ones deemed useful enough to be added
  settings.Add("jak1_misc_tasks", true, "Miscellaneous Tasks");
  vars.miscallenousTasks = new List<Dictionary<String, dynamic>>();
  AddOption(vars.miscallenousTasks, "int_finalboss_movies", structByteIdx++, typeof(byte), 1, true, "int_finalboss_movies", false);
  AddOption(vars.miscallenousTasks, "unk_finalboss_movies", structByteIdx++, typeof(byte), 1, false, "unk_finalboss_movies", false);
  AddOption(vars.miscallenousTasks, "int_jungle_fishgame", structByteIdx++, typeof(byte), 1, false, "int_jungle_fishgame", false);
  AddToSettings(vars.miscallenousTasks, "jak1_misc_tasks");
  vars.optionLists.Add(vars.miscallenousTasks);

  // Treat this one as special, so we can ensure the timer ends no matter what!
  vars.finalSplitTask = vars.miscallenousTasks[0];

  vars.DebugOutput("Finished {startup}");
}

init {
  vars.DebugOutput("Running {init} looking for `gk.exe`");
  var sw = new Stopwatch(); sw.Start();
  var exported_ptr = IntPtr.Zero;
  vars.foundPointers = false;
  byte[] marker = Encoding.ASCII.GetBytes("UnLiStEdStRaTs_JaK1" + Char.MinValue);
  vars.debugTick = 0;

  vars.DebugOutput(String.Format("Base Addr - {0}", modules.First().BaseAddress.ToString("x8")));
  foreach (var page in game.MemoryPages(true)) {
    var scanner = new SignatureScanner(game, page.BaseAddress, (int)page.RegionSize);
    if ((exported_ptr = scanner.Scan(new SigScanTarget(marker.Length, marker))) != IntPtr.Zero) {
      break;
    }
  }

  if (exported_ptr == IntPtr.Zero) {
    vars.DebugOutput("Could not find the AutoSplittingInfo struct, old version of gk.exe? Failing!"); sw.Reset();
    return false;
  }

  Action<MemoryWatcherList, IntPtr, List<Dictionary<String, dynamic>>> AddMemoryWatchers = (memList, bPtr, options) => {
    foreach (Dictionary<String, dynamic> option in options) {
      var finalOffset = bPtr + (option["offset"]);
      // TODO - use the type on the object to make this value properly.  Right now everything is a u8
      memList.Add(new MemoryWatcher<byte>(finalOffset) { Name = option["id"] });
      if (option["debug"] == true) {
        memList[option["id"]].Update(game);
        vars.DebugOutput(String.Format("Debug ({0}) -> ptr [{1}]; val [{2}]", option["id"], finalOffset.ToString("x8"), memList[option["id"]].Current));
      }
    }
  };

  var watchers = new MemoryWatcherList{
    new MemoryWatcher<uint>(exported_ptr + 212) { Name = "currentGameHash" }
  };

  // Init current game has in case script is loaded while game is already started
  watchers["currentGameHash"].Update(game);

  var jak1_need_res_bptr = exported_ptr + 424; // bytes
  foreach (List<Dictionary<String, dynamic>> optionList in vars.optionLists) {
    AddMemoryWatchers(watchers, jak1_need_res_bptr, optionList);
  }
  vars.foundPointers = true;
  vars.watchers = watchers;
  sw.Stop();
  vars.DebugOutput("Script Initialized, Game Compatible.");
  vars.DebugOutput(String.Format("Found the exported struct at {0}", exported_ptr.ToString("x8")));
  vars.DebugOutput(String.Format("It took {0} ms", sw.ElapsedMilliseconds));
}

update {
  if (!vars.foundPointers) {
    return false;
  }

  vars.watchers.UpdateAll(game);
}

reset {
  if (vars.watchers["currentGameHash"].Current != 0 && vars.watchers["currentGameHash"].Current != vars.watchers["currentGameHash"].Old) {
    vars.DebugOutput("Resetting!");
    vars.DebugOutput(String.Format("Reset -> Old: {0}, Curr: {1}", vars.watchers["currentGameHash"].Old, vars.watchers["currentGameHash"].Current));
    return true;
  }
  return false;
}

start {
  if (vars.watchers["currentGameHash"].Current != 0 && vars.watchers["currentGameHash"].Current != vars.watchers["currentGameHash"].Old) {
    vars.DebugOutput("Starting!");
    vars.DebugOutput(String.Format("Start -> Old: {0}, Curr: {1}", vars.watchers["currentGameHash"].Old, vars.watchers["currentGameHash"].Current));
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
        vars.DebugOutput(String.Format("Debug ({0}) -> old [{1}]; current [{2}]", option["id"], watcher.Old, watcher.Current));
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
