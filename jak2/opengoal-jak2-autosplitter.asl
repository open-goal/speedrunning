state("gk") {
  // nothing to do here; we need to grab the pointers ourselves instead of hardcoding them
}

// Runs once, the only place you can add custom settings, before the process is connected to!
startup {
  // NOTE: Enable Log Output
  Action<string, bool> DebugOutput = (text, setting) => {
    if (setting) {
      print("[OpenGOAL] " + text);
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

  // NOTE: This section is autogenerated.  Do not edit it directly.
  // __AUTOGENERATED__ START
  // __AUTOGENERATED__ END

  vars.DebugOutput("Finished {startup}", true);
}

init {
  vars.DebugOutput("Running {init} looking for `gk.exe`", true);
  var sw = new Stopwatch();
  sw.Start();
  var exported_ptr = IntPtr.Zero;
  vars.foundPointers = false;
  byte[] marker = Encoding.ASCII.GetBytes("UnLiStEdStRaTs_JaK2" + Char.MinValue);
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
