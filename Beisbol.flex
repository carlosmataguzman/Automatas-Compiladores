/* Julio César Guzmán Benavides		 A82939	*/
/*	Carlos Alberto Mata Guzmán	 B13980 */
%%

%public
%class AnalizadorBeisbol
%standalone
%line
%unicode

%{
	int [] bases = new int[]{0,0,0,0};
	int carrerasLocal = 0;
	int carrerasVisita = 0;
	int entrada = 1;
	int out = 0;
	
  
%}

Jugador = [0-9]
Ponche = "K"|"k"
OutEnEquipo = ({Jugador}{Jugador})
DobleJugada = "DP"|"Dp"|"dP"|"dp"
OutAereo = (("L"|"fc"){Jugador})
OutYAvance = "FC"|"Fc"|"fC"|"fc"
ErrorYAvance =(("E"|"e"){Jugador})
JugadorGolpeado = "HP"|"Hp"|"hP"|"hp"
BasePorBolas = "BB"|"Bb"|"bB"|"bb"
ToqueSacrificio = "SAC"|"SAc"|"SaC"|"Sac"|"sAC"|"sAc"|"sAC"|"sac"
Hit = "1B"|"1b"
Doble = "2B"|"2b"
Triple = "3B"|"3b"
HomeRun = "4B"|"4b"|"HR"|"Hr"|"hR"|hr

%eof{

%eof}

%%
({Ponche}|{OutAereo}|{OutEnEquipo}) {System.out.println("OUT");out++;}
({DobleJugada}) {System.out.println("DOS OUT");out=out+2;}
({ToqueSacrificio}|{OutYAvance}) {System.out.println("OUT Y AVANZA");out++; base++;}
({ErrorYAvance}|{JugadorGolpeado}|{BasePorBolas}|{Hit}) {System.out.println("AVANZA");base++;}
{Doble} {System.out.println("AVANZA 2");base=base+2;}
{Triple} {System.out.println("AVANZA 3");base=base+3;}
{HomeRun} {System.out.println("HOME RUN!!");base=base+4;}
