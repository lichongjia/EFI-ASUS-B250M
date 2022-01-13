/*
 * 0D/6D wakeup patch
 * In config.plist->ACPI->Patch: GPRW to XPRW
 * Find:     47505257 02
 * Replace:  58505257 02
 */
DefinitionBlock ("", "SSDT", 2, "ACDT", "GPRW", 0x00000000)
{
    External (XPRW, MethodObj)

    Method (GPRW, 2, NotSerialized)
    {
        If (_OSI ("Darwin"))
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
        }

        Return (XPRW (Arg0, Arg1))
    }
}
