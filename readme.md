# setDefaultApps
SetDefaultApps allows you to set default applications for macOS by a configuration profile.
Only configurations via MDM are allowed. Local plist files will be ignored.

To set the default Apps run: `/Library/Application\ Support/Intellec/com.intellec.setDefaultApps/DefaultApps`

Make sure to have set a configuration profile before, otherwise you get a _Only settings set by MDM are allowed._

### Triggers
Multiple triggers can be applied to a handler modification entry. This allows you to group multiple handler modifications together and run them together by specifying the triggername as an argument when running the command.

`/Library/Application\ Support/Intellec/com.intellec.setDefaultApps/DefaultApps trigger1`
If no trigger is specified, the default trigger named "default" is ueed.

At least one trigger has to be defined as part of the handler modification entry. If not, it'll never be applied.

## Configuration Profile
setDefaultApps listens to the __com.intellec.defaultapps__ settings domain.
It has to have am array called __force__ containing dictionaries with the folowwing keys:

Key | Type | Value
--- | --- | ---
Handler | String | Handler to modify
Typ | String | Typ of the handler ( content or url )
AppID | String | the BundleID ot the Application responsible for the handler
Comment | String | A comment for the entry
Trigger | String | A list of triggers seperated by a comma. 

There is no limitations to the number of dictionaries.

For example to set the default browser the config looks like this:

```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>force</key>
	<array>
		<dict>
		  <key>Comment</key>
		  <string>Default browser settings</string>
		  <key>Trigger</key>
		  <string>default, browser, trigger2</string>
		  <key>AppID</key>
		  <string>com.google.Chrome</string>
		  <key>Handler</key>
		  <string>public.xhtml</string>
		  <key>Typ</key>
		  <string>content</string>
		</dict>
		<dict>
		  <key>Comment</key>
		  <string>Default browser settings</string>
		  <key>Trigger</key>
		  <string>default, browser, trigger2</string>
		  <key>AppID</key>
		  <string>com.google.chrome</string>
		  <key>Handler</key>
		  <string>https</string>
		  <key>Typ</key>
		  <string>url</string>
		</dict>
		<dict>
		  <key>Comment</key>
		  <string>Default browser settings</string>
		  <key>Trigger</key>
		  <string>default, browser, trigger2</string>
		  <key>AppID</key>
		  <string>com.google.chrome</string>
		  <key>Handler</key>
		  <string>http</string>
		  <key>Typ</key>
		  <string>url</string>
		</dict>
		<dict>
		  <key>Comment</key>
		  <string>Default browser settings</string>
		  <key>Trigger</key>
		  <string>default, browser, trigger2</string>
		  <key>AppID</key>
		  <string>com.google.Chrome</string>
		  <key>Handler</key>
		  <string>public.html</string>
		  <key>Typ</key>
		  <string>content</string>
		</dict>
	</array>
</dict>
</plist>

```

Have a look at the triggers, there are multiple triggers specified. If you run `/Library/Application\ Support/Intellec/com.intellec.setDefaultApps/DefaultApps` without specifying any triggername, "default" will be used and therefore all handler modification entries containing default as trigger will be run.
