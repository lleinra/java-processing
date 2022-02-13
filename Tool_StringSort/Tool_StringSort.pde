import java.awt.*;
import java.awt.event.*;
import java.awt.datatransfer.*;
import javax.swing.*;
import java.io.*;
//String string = "Mechanical Computer  Magnetic Drum  Magnetic Core  Microprocessor  Monitor  Machine Cycle  Memory  Magnetic Tape  Magnetic Disk  Mouse  Metal Standoffs  Mini Tower Case  Mid Tower Case  Motherboard  Memory Sockets or Slots  Motherboard Form Factors  Mini ITX Motherboards  MicroATX Motherboards  Memory Technology  Media Players  Microsoft Windows  Macintosh OS  Machine Language  Multiplexing Techniques  Multi-user Operating Systems  Memory Manager  Monitor  Mouse  Modem  Megabyte  Memory  Menu  Malware  Megahertz  Mother Board  Microsoft Word  Mesh Topology  Machine Language  My Computer  Magnetic Card  Magnetic Card Reader  Magnetic Storage  Magnetic Storage device  Magnetic Tape  Magnetic Tape Drive  Mail  Mailbomb  Mailbox  Mail merge  Main frame  Maintenance  Malicious user  Malvertising  Malvirus  Menu Key  Menu Butto  Menu Bar  Megawatt";
//String string = "Non-impact printer  Northbridge ChipsetNetwork Manager  NOT Gate (Negation)  NAND GATE  NOR Gate  Number System  Networks  Notepad  Notification Area  NorthBridge  New Line  Numeric Keypad  Namesspace  Navigator";
//String string = "Operating systems  Output devices  Optical Disk  OR Gate (Disjunction)  Operating System  Online  Output  Optical diskOptical Scanner";
//String string = "Program  Punched card  Processor  Peopleware  Pointing devices  pointing stick  Printer  Program Counter  Primary Memory  PROM or Programmable read-only memory  Power Connectors  PCI Express (PCI-E) Slots  PCI (Peripheral Component Interconnect) Slots  Processor Sockets or Slots  Power Supply Units  Pin-Less – Base (Land Grid Array) Processors  Presentation Software  Processor Manager  Peripheral  PDF  Phishing  Plug-in  Post Office Protocol (POP)  Pages Per Minute(PPM)  Processor  Protocol  Printer  Port  PowerPoint  Punch Card";
String string = "Register  RAM or Random Access Memory  ROM or Read-Only Memory  Real-Time Operating Systems  Reboot  Resolution  Router  RAD";
String[] array = new String[5];
String newString = "";
Clipboard clipboard = Toolkit.getDefaultToolkit().getSystemClipboard();

void setup() {
  size(100, 100);
  array = split(string, "  ");
  array = sort(array);
  for (String str : array) {
    newString += str;
    newString += "\n";
  }
  StringSelection data = new StringSelection(newString);
  clipboard.setContents(data, data);
  exit();
}
