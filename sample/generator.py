from os import listdir
from os.path import isfile, join
from fileinput import close

import glob


fileList = glob.glob("*.out")
patterns = {}

for file in fileList:
  intPatterns = {}
  rowPatterns = {}
  with open(file, 'rU') as f:
    for s in f:
      segments = s.split( );
      i = 0
      row = ''
      prefix = ''
      for segment in segments:
        if (i == 0):
          str = ''
          row += "%{WORD:time} "
        else :
          if (i == 1):
            prefix = segment.split(".")[len(segment.split("."))-1]
            row += "%{JAVACLASS:yarnClass}:"
          else:
            tmp = segment.replace(",", "");
            tmpsegments = tmp.split("=")
            if len(tmpsegments) > 1:
              try:
                if int(tmpsegments[1]) == float(tmpsegments[1]):
                  patterns[tmpsegments[0].upper()] = " (" + tmpsegments[0] + "=" + "%{INT:" + tmpsegments[0] + "}" + ")"
                  intPatterns[tmpsegments[0]] = "integer"
              except:
                  try:
                    float(tmpsegments[1])
                    patterns[tmpsegments[0].upper()] = " (" + tmpsegments[0] + "=" + "%{BASE16FLOAT:" + tmpsegments[0] + "}" + ")"
                  except:
                    patterns[tmpsegments[0].upper()] = " (" + tmpsegments[0] + "=" + "%{DATA:" + tmpsegments[0] + "}" + ")"
              if i == len(segments)-1:
                row += " %{" + tmpsegments[0].upper() + "}"
              else:
                row += " %{" + tmpsegments[0].upper() + "},"
            else :
              try:
                if int(tmpsegments[0]) == float(tmpsegments[0]):
                  patterns[tmpsegments[0].upper()] = " (" + "%{INT:" + tmpsegments[0] + "}" + ")"
              except:
                  try:
                    float(tmpsegments[0])
                    patterns[tmpsegments[0].upper()] = " (" + "%{BASE16FLOAT:" + tmpsegments[0] + "}" + ")"
                  except:
                    patterns[tmpsegments[0].upper()] = " (" + "%{DATA:" + tmpsegments[0] + "}" + ")"
              if i == len(segments)-1:
                row += " %{" + tmpsegments[0].upper() + "}"
              else:
                if len(tmpsegments) > 1:
                  row += " %{" + tmpsegments[0].upper() + "},"
                else:
                  row += " %{" + tmpsegments[0].upper() + "}"
        i+=1
      rowPatterns["ROW_" + prefix.upper().replace(":","")] = " " + row
    with open("shipper-hadoop-metrics-" + f.name.replace(".out","") + ".conf", 'a') as the_file:
      result = 'input {\nfile {\n  type => "'
      result += f.name.replace(".out","")
      result += '"\n    start_position => "beginning"\n    path => [ "/amb/log/hadoop-yarn/metrics/'
      result += f.name.replace(".out","")
      result += '.out" ]\n  }\n}\nfilter {\n  if [type] == "'
      result += f.name.replace(".out","")
      result += '\" {\n    grok {\n      patterns_dir => "/etc/logstash/conf.d/patterns"\n      match => [\n'
      rowindex = 0
      for k,v in rowPatterns.items():
        if len(rowPatterns.items())-1==rowindex:
          result += '\t\t\t\t"message", "'+v.replace(" ", "", 1)+'"\n'
        else:
          result += '\t\t\t\t"message", "'+v.replace(" ", "", 1)+'",\n'
        rowindex+=1
      result += '\t\t\t]\n    }\n    ruby {\n      code => '
      result += "'"
      result += '\n          require "time"\n          event["heatmap"] = Time.parse(event["@timestamp"].to_s).strftime "%u-" + (Time.parse(event["@timestamp"].to_s).strftime "%a") + (Time.parse(event["@timestamp"].to_s).strftime ":%H-") + ((Time.parse(event["@timestamp"].to_s) + 60*60).strftime "%H");\n'
      result += "\t\t'\n"
      result += '\t\t}\n'
      result += '\tmutate {\n'
      result += '\t\tconvert => ['
      for idx, v in enumerate(intPatterns.keys()):
        if(idx != 0):
          result += ','
        result += '\n\t\t\t"' + v + '", "integer"'
      result += '\t\t]\n'
      result += '\t\t}\n'
      result += '\t}\n'
      result += '}\n'
      the_file.write(result)
with open("metrics", 'a') as metricsfile:
  for k,v in patterns.items():
    metricsfile.write(k+v+"\n")
