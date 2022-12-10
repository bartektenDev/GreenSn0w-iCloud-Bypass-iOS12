import re
import tkinter as tk
from tkinter import *
from tkinter import messagebox
import os
import time

from subprocess import run


root = tk.Tk()
frame = tk.Frame(root)

#root.iconbitmap('blackrain.ico')
#root.iconphoto(False, tk.PhotoImage(file='blackrainicon.png'))


LAST_CONNECTED_UDID = ""
LAST_CONNECTED_IOS_VER = ""



def detectDevice():
    global LAST_CONNECTED_UDID, LAST_CONNECTED_IOS_VER
    #step 1 technically
    print("Searching for connected device...")
    os.system("ideviceinfo > lastdevice.txt")

    f = open("lastdevice.txt", "r")
    fileData = f.read()
    f.close()

    if("ERROR: No device found!" in fileData):
        #no device was detected, so retry user!
        print("ERROR: No device found!")

        messagebox.showinfo("No device detected! 0x404","Try reconnecting your device...")
        
        label.config(text = "Try reconnecting your device...", bg = "lightgrey", fg = "black")
        
    else:
        #we definitely have something connected...

        #find the UDID
        start = 'UniqueDeviceID: '
        end = 'UseRaptorCerts:'
        s = str(fileData)

        foundData = s[s.find(start)+len(start):s.rfind(end)]
        UDID = str(foundData)
        LAST_CONNECTED_UDID = str(UDID)

        #find the iOS
        #we definitely have something connected...
        start2 = 'ProductVersion: '
        end2 = 'ProductionSOC:'
        s2 = str(fileData)

        foundData2 = s2[s.find(start2)+len(start2):s2.rfind(end2)]
        deviceIOS = str(foundData2)
        LAST_CONNECTED_IOS_VER = str(deviceIOS)
        
        HIGHEST_SUPPORTED_IOS_VER = str("12.5.6")
        
        #remove any weird characters in the iOS ver
        floatLAST_CONNECTED_IOS_VER = LAST_CONNECTED_IOS_VER.replace("\n","")
        m = re.findall(r'\d+\.\d+', LAST_CONNECTED_IOS_VER)
        my_float1 = float(m[0])
        
        m2 = re.findall(r'\d+\.\d+', HIGHEST_SUPPORTED_IOS_VER)
        my_float2 = float(m2[0])

        if(len(UDID) > 20):
            #stop automatic detection
            timerStatus = 0

            label.config(text = "Found iDevice on iOS "+LAST_CONNECTED_IOS_VER)
            print("Found UDID: "+LAST_CONNECTED_UDID)
            #messagebox.showinfo("iDevice is detected!","Found iDevice on iOS "+LAST_CONNECTED_IOS_VER)
            
            if(my_float1 >= float("12.0")):
                #device is higher than ios 12!
                
                
                if(my_float1 <= my_float2):
                    #device is lower than ios 12.5.6!
                    
                    label.config(text = "Found iDevice on iOS "+LAST_CONNECTED_IOS_VER+"\nThis device is SUPPORTED!", bg = "green", fg = "white")
                    
                    #messagebox.showinfo("iDevice is Supported!","This device is SUPPORTED!")
                    messagebox.showinfo("iDevice is Supported!","Click 'Start checkra1n' to begin jailbreak.\n\nAfter you jailbreak, then click 'Inject Payload' and finally 'Make it Sn0w' to run iCloud Bypass.")
                    
            if(my_float1 < float("12.0")):
                #device is lower than ios 12!
                #messagebox.showinfo("iDevice is not supported!","This device is not supported :(")
                
                label.config(text = "Found iDevice on iOS "+LAST_CONNECTED_IOS_VER+"\nThis device is not supported :(", bg = "red", fg = "white")
                
            if(my_float1 > my_float2):
                #device is higher than ios 14.7.1!
                #messagebox.showinfo("iDevice is not supported!","This device is not supported :(")
                
                label.config(text = "Found iDevice on iOS "+LAST_CONNECTED_IOS_VER+"\nThis device is not supported :(", bg = "red", fg = "white")
                
        else:
            print("Couldn't find your device")



def showDFUMessage():
    messagebox.showinfo("Step 1","Put your iDevice into DFU mode.\n\nClick Ok once its ready in DFU mode to proceed.")


def exploitCheckra1n():
    global LAST_CONNECTED_UDID, LAST_CONNECTED_IOS_VER
    
#    messagebox.showinfo("Begin checkra1n jailbreak","WARNING! This may take a couple of attempts!\n\nPut device into DFU mode. Click Ok once device is ready.")
    
    #time.sleep(2)
    
#    print("Killing Finder...")
#    os.system("killall Finder")
    
    print("Starting checkra1n jailbreak...")
    os.system("./extras/checkra1n/checkra1n -c -V -E")
    print("Device is jailbroken!\n")
    messagebox.showinfo("checkra1n Done!","Jailbreak Complete!\n\nIf you see a verbose boot (text loading on iDevice) you did this step right. Now you can click 'Make it Sn0w!' to begin bypass.\n\nIf it failed, try again.")
    
    
def exploitInjectPayload():
    global LAST_CONNECTED_UDID, LAST_CONNECTED_IOS_VER
    
    messagebox.showinfo("Step 1","💉 Inject Payload.\n\nMake sure device is jailbroken and connected in normal mode.\n\nClick Ok once device is ready.")
    
    time.sleep(2)
    
    print("Loading payload script...")
    os.system("bash ./inject.sh")
    print("Payload script ran!\n")

def exploitGreenSn0w():
    global LAST_CONNECTED_UDID, LAST_CONNECTED_IOS_VER
    
    messagebox.showinfo("Begin GreenSn0w iCloud Bypass","Make sure device is connected in normal mode. Click Ok once device is ready.")
    
    time.sleep(2)
    
    print("Loading ❄️ GreenSn0w script...")
    path = os.getcwd()
    print(path)
    os.system("bash ./greensn0w.sh")
    print("❄️ GreenSn0w script ran!\n")


def startSSHServer():
    os.system("iproxy 4444 44")

def quitProgram():
    print("Exiting...")
    os.system("exit")


root.title('GreenSn0w v1.1 - iOS 12.0-12.5.6 iCloud Activation Lock Bypass - @ios_euphoria')
frame.pack()

label = Label(frame, text = "Please connect iDevice in normal mode", bg = "lightgrey", bd = 10, fg = "black", font = "Castellar")
label.pack(side=tk.TOP)

cdetectDevice = tk.Button(frame,
                   text="Pair iDevice",
                   command=detectDevice)
cdetectDevice.pack(side=tk.TOP)

cbeginExploit = tk.Button(frame,
                   text="Start checkra1n",
                   command=exploitCheckra1n,
                   state="normal")
cbeginExploit.pack(side=tk.TOP)

cbeginExploit5 = tk.Button(frame,
                   text="Inject Payload 💉",
                   command=exploitInjectPayload,
                   state="normal")
cbeginExploit5.pack(side=tk.TOP)

cbeginExploit2 = tk.Button(frame,
                   text="Make it Sn0w ❄️",
                   command=exploitGreenSn0w,
                   state="normal")
cbeginExploit2.pack(side=tk.TOP)


root.geometry("600x230")

root.eval('tk::PlaceWindow . center')

root.mainloop()
