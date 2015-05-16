/* Julio César Guzmán Benavides			*/
/*	Carlos Alberto Mata Guzmán	 B13980 */
%%

%public
%class AnalizadorBeisbol
%standalone
%unicode


%{
/*------------------- ATRIBUTOS DE LA CLASE -----------------------------------*/
int [] vecBases = new int[]{0,0,0,0};
int carrerasLocal = 0;
int carrerasVisita = 0;
int outs=0;
String bases = "O  O  O";

/*------------------------------MÉTODOS DE IMPRESIÓN---------------------------------*/
void Imprimir(){
	System.out.println("*---------------------------------------------------*\n");
	System.out.println("|  CASA    |  OUT  |  ENTRADA  |  BASES  |  VISITA  |\n");
	System.out.println("|----------+-------+-----------+---------+----------+\n");
	System.out.println(PonerDatos());
	System.out.println("*---------------------------------------------------*\n");
}
String PonerDatos(){
	String ayudante = "";
	ayudante = PonerBlancos(Integer.toString(casa),7); //La columna CASA tiene 10 espacios, se empieza a escribir al 3ro.
	String resultado = "|   "+ayudante+"|   "+(outs+3)%3+"   ";  //Se suma 3 a los outs para el caso de los 3 primeros outs del juego.
	ayudante = PonerBlancos(Integer.toString((outs/6)+1),4); //Espacios en blanco para la columna ENTRADA.
	if(outs%6>2){//Se indica cuál equipo está bateandao, ALTA=CASA, BAJA=VISITA
		resultado = resultado+"| ALTA  "+ayudante+"|         "; //Falta completar bases
	}else{
		resultado = resultado+"| BAJA  "+ayudante+"|         ";
	}
	ayudante = PonerBlancos(Integer.toString(visita),7); //La columna VISITA tiene 10 espacios, se empieza a escribir al 3ro.
	resultado = resultado+"|   "+ayudante+"|\n";
	return resultado;
}

String PonerBlancos(String palabra, int tamanoEspacio){
	String resultado=palabra;
	for(int i=0;i<(tamanoEspacio-palabra.length());i++){
		resultado = resultado+" ";
	}
	return resultado;
}

String PonerBases(){
	String resultado = "O  O  O";
	for(int i=0; i<3; i++){
		if(1==vecBases[i])resultado.charAt(i*3)='C'; 
	}
	return resultado;
}

void revisarCarreras(int carreras){
		boolean casa = true;
		if(outs%6<3)casa = false;
		if(vecBases[3]==1){
		      if(casa){
		          carrerasLocal= carrerasLocal+carreras;
		      }
			  else{
		           carrerasVisita= carrerasLocal+carreras;
		      }
		      vecBases[3]=0;
		}			
}		    

void avanzarBases(){
	vecBases[3]=vecBases[2];
	vecBases[2]=vecBases[1];
	vecBases[1]=vecBases[0];
	vecBases[0]=1;
}
/*------------------- MÉTODO EMULADOR DE JUEGO -----------------------*/
void base(int situacion){
	switch(situacion){	    
	    case 1:      //Busca al jugador en la base más avanzada y lo elimina
			avanzarBases();
			boolean limpiarBase = false;
			int i = 3;
			while((i>=0)&&(!limpiarBase)){
				if(vecBases[i]==1){
					vecBases[i]=0;
					limpiarBase = true;
				}
				i--;
			} 
	    	  //out++;
	    	break;
	    case 2:                          //Double Play 
			avanzarBases();
			int out = 0;
	    	int i = 3;
	    	while((out<3)&&(i>=0)){
				if(vecBases[i]==1){
					vecBases[i]=0;
					out++;
	    	  	}
	    	}
			break;
	    case 3:            //Avance normal
			avanzarBases();
	    	revisarCarreras(1);
	    	break;
	    case 4: 			//Bateador avanzo a segunda
			avanzarBases();
			revisarCarreas(1);
			avanzarBases();
			vecBases[0]=0;
	        revisarCarreras(1);
	        break;
	     case 5:			//	Bateador avanzo a Tercera
			avanzarBases();
			revisarCarreas(1);
			avanzarBases();
			vecBases[0]=0;
	        revisarCarreras(1);
	        avanzarBases();
	        vecBases[1]=0;
	        vecBases[0]=0;
			revisarCarreras(1);
			break;
	     case 6:			// Bateador avanzo a Cuarta
			int hombresEnBase = 1;
	        for(int i = 0; i<4; i++){
				if(vecBases[i]==1){
					hombresEnBase++;
				}
	        }
	        revisarCarreas(hombresEnBase);
	        for(int i = 0; i<4; i++){
				vecBases[i] = 0;
	        }
	        break;
	    case 7:                 //Base por bolas y jugador golpeado 
	    	 if(vecBases[0]==0){
	    	       vecBases[0]=1;         //Bateador va a primera
	    	 }
	    	 else{
	    	      if(vecBases[1]==0){          //Segunda esta vacia
	    	            vecBases[1]=vecBases[0];
	    	            vecBases[0]=1;
	    	      }
	    	      else{                        // Primera y segunda llenas
	    	            avanzarBases();
	    	            revisarCarreras(1);
	    	      }
	    	 }
	    }  
  }

/*--------- GRAMÁTICA  --------------*/  

%}

Jugador = [0-9]
Ponche = "K"|"k"
OutEnEquipo = ({Jugador}{Jugador})
DobleJugada = "DP"|"Dp"|"dP"|"dp"
OutAereo = (("L"|"l"){Jugador})
OutYAvance = "FC"|"Fc"|"fC"|"fc"
ErrorYAvance =(("E"|"e"){Jugador})
JugadorGolpeado = "HP"|"Hp"|"hP"|"hp"
BasePorBolas = "BB"|"Bb"|"bB"|"bb"
ToqueSacrificio = "SAC"|"SAc"|"SaC"|"Sac"|"sAC"|"sAc"|"sAC"|"sac"
Hit = "1B"|"1b"
Doble = "2B"|"2b"
Triple = "3B"|"3b"
HomeRun = "4B"|"4b"|"HR"|"Hr"|"hR"|hr


/*----------INSTRUCIONES DE FIN DE ARCHIVO------------*/
%eof{
Imprimir();
System.out.println("***FIN DEL ANALISIS***\n");

%eof}

/*---------- COMPONENTES LÉXICOS ---------------------*/

%%
//({Ponche}|{OutAereo}|{OutEnEquipo}) {System.out.println("OUT");outs++;} //nunca generan movimiento en bases. Out en equipo talvez.
//({DobleJugada}) {System.out.println("DOS OUT");outs=outs+2;}
//({ToqueSacrificio}|{OutYAvance}) {System.out.println("OUT Y AVANZA");outs++; base++;}
//({ErrorYAvance}|{JugadorGolpeado}|{BasePorBolas}|{Hit}) {System.out.println("AVANZA");base++;}
//{Doble} {System.out.println("AVANZA 2");base=base+2;}
//{Triple} {System.out.println("AVANZA 3");base=base+3;}
//{HomeRun} {System.out.println("HOME RUN!!");base=base+4;}
//. {}



({Ponche}|{OutAereo}) {outs++;} //Solo aumenta un out, no cambia las bases
({OutEnEquipo}|{OutYAvance}|{ToqueSacrificio}) {this.bases(1);outs++;} //Out al jugador en la base más avanzada, cambia las bases aumenta los outs
({DobleJugada}) {this.bases(2);outs=outs+2;}  // Hay que eliminar dos jugadores contrarios y agregar dos outs
({ErrorYAvance}|{Hit}) {bases(3);}
{Doble} {bases(4);}
{Triple} {bases(5);}
{HomeRun} {bases(6);}
({BasePorBolas}|{JugadorGolpeado}) {bases(7);}
. {}
/*FC y DP: al máximo avance y si no hay al bateador.*/
/*En out aéreo NADIE AVANZA y se hace out al BATEADOR*/
/*En doble play HAY OUTS A LAS ULTIMAS POSICIONES*/