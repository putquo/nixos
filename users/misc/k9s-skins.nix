{
  rose-pine-dawn =
    let
      text = "#575279";
      base = "#faf4ed";
      overlay = "#f2e9e1";
      muted = "#9893a5";
      rose = "#d7827e";
      pine = "#286983";
      gold = "#ea9d34";
      iris = "#907aa9";
      love = "#b4637a";
    in
    {

      k9s = {
        body = {
          fgColor = text;
          bgColor = base;
          logoColor = iris;
        };

        prompt = {
          fgColor = text;
          bgColor = base;
          suggestColor = iris;
        };

        info = {
          fgColor = iris;
          sectionColor = text;
        };

        dialog = {
          fgColor = text;
          bgColor = base;
          buttonFgColor = text;
          buttonBgColor = iris;
          buttonFocusFgColor = gold;
          buttonFocusBgColor = iris;
          labelFgColor = gold;
          fieldFgColor = text;
        };

        frame = {
          border = {
            fgColor = text;
            focusColor = overlay;
          };

          menu = {
            fgColor = text;
            keyColor = iris;
            numKeyColor = iris;
          };

          crumbs = {
            fgColor = text;
            bgColor = overlay;
            activeColor = overlay;
          };

          status = {
            newColor = rose;
            modifyColor = iris;
            addColor = pine;
            errorColor = love;
            highlightcolor = gold;
            killColor = muted;
            completedColor = muted;
          };

          title = {
            fgColor = text;
            bgColor = overlay;
            highlightColor = gold;
            counterColor = iris;
            filterColor = iris;
          };
        };

        views = {
          charts = {
            bgColor = "default";
            defaultDialColors = [ iris love ];
            defaultChartColors = [ iris love ];
          };

          table = {
            fgColor = text;
            bgColor = base;
            header = {
              fgColor = text;
              bgColor = base;
              sorterColor = rose;
            };
          };

          xray = {
            fgColor = text;
            bgColor = base;
            cursorColor = overlay;
            graphicColor = iris;
            showIcons = false;
          };

          yaml = {
            keyColor = iris;
            colonColor = iris;
            valueColor = text;
          };

          logs = {
            fgColor = text;
            bgColor = base;
            indicator = {
              fgColor = text;
              bgColor = iris;
            };
          };
        };
      };
    };

  rose-pine-moon =
    let
      text = "#e0def4";
      base = "#232136";
      overlay = "#393552";
      muted = "#6e6a86";
      rose = "#ea9a97";
      pine = "#3e8fb0";
      gold = "#f6c177";
      iris = "#c4a7e7";
      love = "#eb6f92";
    in
    {
      k9s = {
        body = {
          fgColor = text;
          bgColor = base;
          logoColor = iris;
        };

        prompt = {
          fgColor = text;
          bgColor = base;
          suggestColor = iris;
        };

        info = {
          fgColor = iris;
          sectionColor = text;
        };

        dialog = {
          fgColor = text;
          bgColor = base;
          buttonFgColor = text;
          buttonBgColor = iris;
          buttonFocusFgColor = gold;
          buttonFocusBgColor = iris;
          labelFgColor = gold;
          fieldFgColor = text;
        };

        frame = {
          border = {
            fgColor = overlay;
            focusColor = overlay;
          };

          menu = {
            fgColor = text;
            keyColor = iris;
            numKeyColor = iris;
          };

          crumbs = {
            fgColor = text;
            bgColor = overlay;
            activeColor = overlay;
          };

          status = {
            newColor = rose;
            modifyColor = iris;
            addColor = pine;
            errorColor = love;
            highlightcolor = gold;
            killColor = muted;
            completedColor = muted;
          };

          title = {
            fgColor = text;
            bgColor = overlay;
            highlightColor = gold;
            counterColor = iris;
            filterColor = iris;
          };
        };

        views = {
          charts = {
            bgColor = "default";
            defaultDialColors = [ iris love ];
            defaultChartColors = [ iris love ];
          };

          table = {
            fgColor = text;
            bgColor = base;
            header = {
              fgColor = text;
              bgColor = base;
              sorterColor = rose;
            };
          };

          xray = {
            fgColor = text;
            bgColor = base;
            cursorColor = overlay;
            graphicColor = iris;
            showIcons = false;
          };

          yaml = {
            keyColor = iris;
            colonColor = iris;
            valueColor = text;
          };

          logs = {
            fgColor = text;
            bgColor = base;
            indicator = {
              fgColor = text;
              bgColor = iris;
            };
          };
        };
      };
    };
}
