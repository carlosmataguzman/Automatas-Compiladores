/* Julio César Guzmán Benavides		 A82939	*/
/*	Carlos Alberto Mata Guzmán	 B13980 */
%%

%public
%class AnalizadorBeisbol
%standalone
%line
%unicode

%{
	int [] vecBases = new int[]{0,0,0,0};
	int carrerasLocal = 0;
	int carrerasVisita = 0;
	int entrada = 1;
	int out = 0;
	
	public void bases(int situacion){
	    swich(situacion){
	    case 0:             //no cambian las bases
	          out++;
	          break;
	    }
	    case 1:      //Busca al jugador en la base más avanzada y lo elimina
	    	  vecBases[3]=vecBases[2];
	    	  vecBases[2]=vecBases[1];
	    	  vecBases[3]=vecBases[0];
	    	  vecBases[0]=1;
	    
	    	  boolean limpiarBase = false;
	    	  int i = 3;
	    	  while((i>=0)&&(!limpiarBase)){
	              if(vecBases[i]==1){
	              	  vecBases[i]=0;
	              	  limpiarBase = true;
	              }
	              i--
	          } 
	    	  out++;
	    	  break;
	    case 2:
	    	  int hombresEnBase = 0;
	    	  for(int i=0; i<4; ++i){
	    	  	if(vecBases[i]==1){
	    	  	    hombresEnBase++;
	    	  	}
	    	  }
	    	  if(hombresEnBase<2){
	    	  	for(int i=0; i<4; i++){
	    	  	     vecBases[i]=0;
	    	  	}
	    	  	out+=2;
	    	  }
	    	  else{
	    	  	if(hombresEnBase == 2){
	    	  	    for(int i=0; i<4; i++){
	    	  	        vecBases[i]=0;
	    	  	    }
	    	  	 out+=2;
	    	  	 }
	    	         else{
	    	  	     vecBases[2]==0;
	    	  	     out+=2;
	    	  	}
	    	  }
	    	  break;
	    case 3:
	          vecBases[3]=vecBases[2];
	    	  vecBases[2]=vecBases[1];
	    	  vecBases[3]=vecBases[0];
	    	  vecBases[0]=1;
	}
  
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
({Ponche}){bases(0);} //Solo aumenta un out, no cambia las bases
({OutEnEquipo}){bases(1);} //Out al jugador en la base más avanzada, cambia las bases aumenta los outs
({OutAereo} {bases(0);}    //Solo aumenta un out, no cambia las bases
({DobleJugada}) {bases(2);}  // Hay que eliminar dos jugadores contrarios y agregar dos outs
({ToqueSacrificio} {bases(1);}  //Out al jugador en la base más avanzada, cambia las bases aumenta los outs
{OutYAvance}) {bases(1);}    //Solo aumenta un out, no cambia las bases
({ErrorYAvance}|{JugadorGolpeado}|{BasePorBolas}|{Hit}) {base(3);}
{Doble} {System.out.println("AVANZA 2");base=base+2;}
{Triple} {System.out.println("AVANZA 3");base=base+3;}
{HomeRun} {System.out.println("HOME RUN!!");base=base+4;}
