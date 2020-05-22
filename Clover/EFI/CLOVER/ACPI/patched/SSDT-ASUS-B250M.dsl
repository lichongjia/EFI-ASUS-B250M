/*
 * This file is a tiny SSDT for ASUS-B250M.
 * It's a alternate for all SSDT patches.
 * Credit: @JFZ (https://github.com/lichongjia)
 */
DefinitionBlock ("", "SSDT", 2, "JFZ", "TinySSDT", 0x00001000)
{
    External (_SB_.PCI0, DeviceObj)
    External (_SB_.PCI0.LPCB, DeviceObj)
    External (_SB_.PCI0.SBUS.BUS0, DeviceObj)
    External (_PR_.CPU0, ProcessorObj)
/*  External (XPRW, MethodObj)  // 0D/6D wakeup patch  */

If (_OSI ("Darwin"))
{
    Scope (\_SB)
    {
        Scope (PCI0)
        {
            Scope (LPCB)
            {
                /* Add Device ALS0.
                 * Starting with macOS 10.15 Ambient Light Sensor presence is required for backlight functioning.
                 */
                Device (ALS0)
                {
                    Name (_HID, "ACPI0008" /* Ambient Light Sensor Device */)  // _HID: Hardware ID
                    Name (_CID, "smc-als")  // _CID: Compatible ID
                    Name (_ALI, 0x012C)  // _ALI: Ambient Light Illuminance
                    Name (_ALR, Package (0x01)  // _ALR: Ambient Light Response
                    {
                        Package (0x02)
                        {
                            0x64, 
                            0x012C
                        }
                    })
                }

                /* Add Device EC.
                 * AppleUsbPower compatibility table for legacy hardware.
                 */              
                Device (EC)
                {
                    Name (_HID, "ACID0001")  // _HID: Hardware ID
                }
                
                /* Add Device DMAC */              
                Device (DMAC)
                {
                    Name (_HID, EisaId ("PNP0200"))
                    Name (_CRS, ResourceTemplate ()
                    {
                        IO (Decode16,
                            0x0000,             // Range Minimum
                            0x0000,             // Range Maximum
                            0x01,               // Alignment
                            0x20,               // Length
                            )
                        IO (Decode16,
                            0x0081,             // Range Minimum
                            0x0081,             // Range Maximum
                            0x01,               // Alignment
                            0x11,               // Length
                            )
                        IO (Decode16,
                            0x0093,             // Range Minimum
                            0x0093,             // Range Maximum
                            0x01,               // Alignment
                            0x0D,               // Length
                            )
                        IO (Decode16,
                            0x00C0,             // Range Minimum
                            0x00C0,             // Range Maximum
                            0x01,               // Alignment
                            0x20,               // Length
                            )
                        DMA (Compatibility, NotBusMaster, Transfer8_16, )
                            {4}
                    })
                }
            }//LPCB
            
            /*
             * Add Device MCHC.
             * SMBus compatibility table.
             */
            Device (MCHC)
            {
                Name (_ADR, Zero)  // _ADR: Address
            }

            Device (SBUS.BUS0)
            {
                Name (_CID, "smbus")  // _CID: Compatible ID
                Name (_ADR, Zero)  // _ADR: Address
                Device (DVL0)
                {
                    Name (_ADR, 0x57)  // _ADR: Address
                    Name (_CID, "diagsvault")  // _CID: Compatible ID
                    Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
                    {
                        If (!Arg2)
                        {
                            Return (Buffer (One)
                            {
                                 0x57                                             // W
                            })
                        }

                        Return (Package (0x02)
                        {
                            "address", 
                            0x57
                        })
                    }
                }
            }
        }//PCI0

        /* Add Device PNLF */
        Device (PNLF)
        {
            Name (_HID, EisaId ("APP0002"))  // _HID: Hardware ID
            Name (_CID, "backlight")  // _CID: Compatible ID
            //Skylake/KabyLake/KabyLake-R
            Name (_UID, 16)  // _UID: Unique ID
        }    
    
        /* Add Device USBX */
        Device (USBX)
        {
            Name (_ADR, Zero)  // _ADR: Address
            Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
            {
                If ((Arg2 == Zero))
                {
                    Return (Buffer (One)
                    {
                         0x03                                             // .
                    })
                }

                Return (Package (0x08)
                {
                    "kUSBSleepPowerSupply",
                    0x13EC,
                    "kUSBSleepPortCurrentLimit",
                    0x0834,
                    "kUSBWakePowerSupply",
                    0x13EC,
                    "kUSBWakePortCurrentLimit",
                    0x0834
                })
            }
        }
    }//\_SB

    /*
     * 0D/6D wakeup patch
     * In config ACPI, GPRW to XPRW
     * Find:     47505257 02
     * Replace:  58505257 02
     */

    /**
    Method (GPRW, 2, NotSerialized)
    {
        While (One)
        {
            If ((0x6D == Arg0))
            {
                Return (Package ()
                {
                    0x6D, 
                    Zero
                })
            }

            If ((0x0D == Arg0))
            {
                Return (Package ()
                {
                    0x0D, 
                    Zero
                })
            }
            
            Break
        }

        Return (XPRW (Arg0, Arg1))
    }
    **/

    /* Add Device MEM2 */
    Device (MEM2)
    {
        Name (_HID, EisaId ("PNP0C01"))
        Name (_UID, 0x02)
        Name (CRS, ResourceTemplate ()
        {
            Memory32Fixed (ReadWrite,
                0x20000000,         // Address Base
                0x00200000,         // Address Length
                )
            Memory32Fixed (ReadWrite,
                0x40000000,         // Address Base
                0x00200000,         // Address Length
                )
        })
        Method (_CRS, 0, NotSerialized)
        {
            Return (CRS)
        }
    }

    /* XCPM power management compatibility table */
    Scope (\_PR.CPU0)
    {
        Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
        {
            Local0 = Package (0x02)
                {
                    "plugin-type", 
                    One
                }
            DTGP (Arg0, Arg1, Arg2, Arg3, RefOf (Local0))
            Return (Local0)
        }
    }

    /* Add DTGP Method */
    Method (DTGP, 5, NotSerialized)
    {
        If ((Arg0 == ToUUID ("a0b5b7c6-1318-441c-b0c9-fe695eaf949b")))
        {
            If ((Arg1 == One))
            {
                If ((Arg2 == Zero))
                {
                    Arg4 = Buffer (One)
                        {
                             0x03                                             // .
                        }
                    Return (One)
                }

                If ((Arg2 == One))
                {
                    Return (One)
                }
            }
        }

        Arg4 = Buffer (One)
            {
                 0x00                                             // .
            }
        Return (Zero)
    }
}//IF OS=Darwin
}