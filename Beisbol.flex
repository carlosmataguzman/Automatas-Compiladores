/* Julio César Guzmán Benavides		 A82939	*/
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
	ayudante = PonerBlancos(Integer.toString(carrerasLocal),7); //La columna CASA tiene 10 espacios, se empieza a escribir al 3ro.
	String resultado = "|   "+ayudante+"|   "+(outs+3)%3+"   ";  //Se suma 3 a los outs para el caso de los 3 primeros outs del juego.
	ayudante = PonerBlancos(Integer.toString((outs/6)+1),4); //Espacios en blanco para la columna ENTRADA.
	if(outs%6>3){//Se indica cuál equipo está bateandao, ALTA=CASA, BAJA=VISITA
		resultado = resultado+"| ALTA  "+ayudante; //Falta completar bases
	}else{
		resultado = resultado+"| BAJA  "+ayudante;
	}
	ayudante = PonerBases();
	resultado = resultado+"|"+ayudante;
	ayudante = PonerBlancos(Integer.toString(carrerasVisita),7); //La columna VISITA tiene 10 espacios, se empieza a escribir al 3ro.
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
	String resultado = "";
	for(int i=0; i<3; i++){
		resultado = (1==vecBases[i])?resultado+" C ":resultado+" O "; 
	}
	return resultado;
}

/*-------------------MÉTODOS DE CONTROL DE JUEGO---------------------*/

void revisarCarreras(int carreras){
		for(int i =0; i<4; i++){
		System.out.println(vecBases[i]+" ");
		}
		boolean casa = true;
		if(outs%6<3)casa = false;
		if(vecBases[3]==1){
		      if(casa){
		          carrerasLocal= carrerasLocal+carreras;
		      }
			  else{
		           carrerasVisita= carrerasVisita+carreras;
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

void bases(int situacion){
	
	if(outs%3==0&&outs!=0){ //Revisa si ya se acabó la entrada.
		for(int i=0; i<4; i++){
			vecBases[i]=0; 
		}
	}
	switch(situacion){	    
	    case 1:      //Busca al jugador en la base más avanzada y lo elimina
			avanzarBases();
			boolean limpiarBase = false;
			int j = 3;
			while((j>=0)&&(!limpiarBase)){
				if(vecBases[j]==1){
					vecBases[j]=0;
					limpiarBase = true;
				}
				j--;
			} 
	    	break;
	    case 2:                          //Double Play 
			avanzarBases();
	    	int out =0;
			int k = 3;
			while(out!=2){	
				if(vecBases[k]==1){
					vecBases[k]=0;
					out++;
				}
				k--;
	    	}
			break;
	    case 3:            //Avance normal
			avanzarBases();
	    	revisarCarreras(1);
	    	break;
	    case 4: 			//Bateador avanzo a segunda
			avanzarBases();
			revisarCarreras(1);
			avanzarBases();
			vecBases[0]=0;
	        revisarCarreras(1);
	        break;
	     case 5:			//	Bateador avanzo a Tercera
			avanzarBases();
			revisarCarreras(1);
			avanzarBases();
			vecBases[0]=0;
	        revisarCarreras(1);
	        avanzarBases();
	        vecBases[0]=0;
	        vecBases[1]=0;
			revisarCarreras(1);
			break;
	     case 6:			// Bateador avanzo a Cuarta
			int hombresEnBase = 1;
	        for(int i = 0; i<4; i++){
				if(vecBases[i]==1){
					hombresEnBase++;
				}
	        }
	        if(outs%6>2){
				carrerasLocal=hombresEnBase+carrerasLocal;
			}
			else{
				carrerasVisita=hombresEnBase+carrerasVisita;
			}
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
			break;
		case 8: // Toque de Sacrificio
			avanzarBases();
			revisarCarreras(1);
			vecBases[0]=0;
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
System.out.println(carrerasLocal+" "+outs+" "+carrerasVisita+"\n");
for(int i =0; i<4; i++){
		System.out.println(vecBases[i]+" ");
}
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
({OutEnEquipo}|{OutYAvance}) {outs++;bases(1);} //Out al jugador en la base más avanzada, cambia las bases aumenta los outs
({DobleJugada}) {bases(2);outs=outs+2;}  // Hay que eliminar dos jugadores contrarios y agregar dos outs
({ErrorYAvance}|{Hit}) { bases(3);}
{Doble} {bases(4);}
{Triple} {bases(5);}
{HomeRun} {bases(6);}
({BasePorBolas}|{JugadorGolpeado}) {bases(7);}
{ToqueSacrificio} {bases(8);} /*Avanzar todos y poner en blanco primera*/
. {}
/*FC y DP: al máximo avance y si no hay al bateador.*/
/*En out aéreo NADIE AVANZA y se hace out al BATEADOR*/
/*En doble play HAY OUTS A LAS ULTIMAS POSICIONES*/
