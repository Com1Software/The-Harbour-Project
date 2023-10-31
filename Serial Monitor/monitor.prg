#include "hbcom.ch"

FUNCTION Main( )

   LOCAL cString := ""
   LOCAL nTimeOut := 500
   LOCAL nResult
   
   local line:=""
   LOCAL nPort := 0
   local pa:=DetectSerialPorts()
   ?os()
   if len(pa)>0 
      nport=pa[1]
      IF ! hb_comOpen( nPort )
         ? "Cannot open port:", nPort, hb_comGetDevice( nPort ), ;
            "error: " + hb_ntos( hb_comGetError( nPort ) )
      ELSE
         ? "port:", hb_comGetDevice( nPort ), "opened"
         IF ! hb_comInit( nPort, 9600, "N", 8, 1 )
            ? "Cannot initialize port to: 9600:N:8:1", ;
               "error: " + hb_ntos( hb_comGetError( nPort ) )
         ELSE
         
            do while .t.
               cString := Space( 1 )
               nTimeOut := 500 // 500 milliseconds = 0.5 sec.
               nResult := hb_comRecv( nPort, @cString, hb_BLen( cString ),nTimeOut )
      
               IF nResult == 1
                  if asc(cstring)=13
                     ?line
                     line=""
                  else
                     line=line+cstring   
                  endif

               ENDIF
            enddo
         ENDIF
         ? "CLOSE:", hb_comClose( nPort )
      ENDIF
   else
      ?"No Serial Ports Found"
   endif
RETURN

FUNCTION DetectSerialPorts()
   local pa:=array(0)
   local x:=0
   local nPort
   local cPortName:="/dev/ttyACM"

   DO WHILE x < 25
      
      
      
      nPort=x
      IF hb_comOpen( nPort )
         aadd(pa,x)
         hb_comClose( nPort )
      ELSE
         hb_comSetDevice( nPort, cPortName+str(x) )
         IF hb_comOpen( nPort )
            aadd(pa,x)
            hb_comClose( nPort )
         ENDIF

      ENDIF
      x++
   enddo
   
return (pa)
