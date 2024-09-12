#include <iostream>
#include <cmath>
#include <conio.h>  // Para _getch() y detectar teclas
#include <string>
#include <windows.h> // Biblioteca para usar SetConsoleCursorPosition
#include <vector>

#define ARRIBA 72
#define ABAJO 80
#define ENTER 13


using namespace std;

const int ClrCeleste = 11;
const int ClrRojo = 12;
const int ClrBlanco = 15;

const int MAX_HISTORIAL = 15;
vector<string> historial(MAX_HISTORIAL, "");
string message= "nothing yet";


const int presicion_decimales = 5;
const int minBas = 2;
const int maxBas = 16;
const int longNums = 15;

void gotoxy(int x, int y) {
    COORD coord;
    coord.X = x;
    coord.Y = y;
    SetConsoleCursorPosition(GetStdHandle(STD_OUTPUT_HANDLE), coord);
}

void ocultarCursor(char band) {
    HANDLE hConsole = GetStdHandle(STD_OUTPUT_HANDLE);
    CONSOLE_CURSOR_INFO cursorInfo;
    GetConsoleCursorInfo(hConsole, &cursorInfo);
    if(band == 'T')//cursor invisible
    cursorInfo.bVisible = FALSE;
    else if(band=='F')//cursor no invisible
    cursorInfo.bVisible = TRUE;

    SetConsoleCursorInfo(hConsole, &cursorInfo);
}

void impTxtColor(const string& texto, int color) {
    HANDLE hConsole = GetStdHandle(STD_OUTPUT_HANDLE);
    CONSOLE_SCREEN_BUFFER_INFO info;

    GetConsoleScreenBufferInfo(hConsole, &info);
    int colorOriginal = info.wAttributes;

    // Cambiar a mi color
    SetConsoleTextAttribute(hConsole, color);
    cout << texto;
    // Restaurar
    SetConsoleTextAttribute(hConsole, colorOriginal);
}


void CALL_ME(string message_1){
    if(message_1 != "C920An")
    message = message_1;
    gotoxy(0, 0);
    impTxtColor("message: "+ message, ClrRojo);
}

void agregarAlHistorial(const string& resultado) {
    for (int i = MAX_HISTORIAL - 1; i > 0; --i) {
        historial[i] = historial[i - 1];
    }
    historial[0] = resultado;
}


void mostrarHistorial(int x, int y) {
    gotoxy(x, y);
    impTxtColor("Historial:", ClrRojo);
    for (int i = 0; i < MAX_HISTORIAL; ++i) {
        if (!historial[i].empty()) {
            gotoxy(x, y + i + 1);
            cout << (i + 1) << ". " << historial[i];
        }
    }
}

bool esNumerico(const string& str) {
    for (char c : str) {
        if (!isdigit(c)) {
            return false;
        }
    }
    return true;
}

bool validarNumeroEnBase(const string& numero, int base) {
    for (char c : numero) {
        int valor = isdigit(c) ? c - '0' : toupper(c) - 'A' + 10;
        if (valor >= base) {
            return false;  // Si el valor excede el rango permitido para la base
        }
    }
    return true;
}


int convertireEnteroABase10(string numero, int baseActual) { //solo el ENTERO
    int resultado = 0;
    int potencia = numero.size() - 1;

    for (char digito : numero) {
        int valor = isdigit(digito) ? digito - '0' : toupper(digito) - 'A' + 10;
        resultado += valor * pow(baseActual, potencia--);
    }
    return resultado;
}

double convertirDecimalABase10(const string& parteDecimal, int baseActual) {
    double resultado = 0.0;

    for (size_t i = 0; i < parteDecimal.size(); ++i) {
        int valor;

        if (isdigit(parteDecimal[i])) {
            valor = parteDecimal[i] - '0';
        } else if (toupper(parteDecimal[i]) >= 'A' && toupper(parteDecimal[i]) <= 'F') {
            valor = toupper(parteDecimal[i]) - 'A' + 10;
        } else {
            cout << "Error: carácter no válido en la parte decimal." << endl;
            return NAN;  // Retorna NaN si hay un error como enta los datos
        }

        double factor = pow(baseActual, -(static_cast<int>(i) + 1));
        resultado += valor * factor;
    }

    return resultado;
}

void dividirNumero(const string& numero, string& parteEntera, string& parteDecimal) {
    size_t punto = numero.find('.');
    if (punto != string::npos) {
        parteEntera = numero.substr(0, punto);
        parteDecimal = numero.substr(punto + 1);
    } else {
        parteEntera = numero;
        parteDecimal = "";
    }
    //esta bien
}

double convertirABase10(string numero, int baseActual) {
    string parteEntera, parteDecimal;
    dividirNumero(numero, parteEntera, parteDecimal);

    int parteEnteraBase10 = convertireEnteroABase10(parteEntera, baseActual);
    double parteDecimalBase10 = convertirDecimalABase10(parteDecimal, baseActual);

    //CALL_ME("nothing here ", parteDecimalBase10, parteEnteraBase10);

    return parteEnteraBase10 + parteDecimalBase10;
}

string convertirEnteroDesdeBase10(int numero, int baseDeseada) {
    if (numero == 0) return "0";

    string resultado = "";
    while (numero > 0) {
        int resto = numero % baseDeseada;
        resultado = (resto < 10 ? to_string(resto) : string(1, 'A' + (resto - 10))) + resultado;
        numero /= baseDeseada;
    }
    return resultado;
}

string convertirDecimalDesdeBase10(double parteDecimal, int baseDeseada, int precision = presicion_decimales) {
    string resultado = "";
    int contador = 0;

    while (parteDecimal > 0 && contador < precision) {
        parteDecimal *= baseDeseada;
        int entero = static_cast<int>(parteDecimal);
        resultado += (entero < 10 ? to_string(entero) : string(1, 'A' + (entero - 10)));
        parteDecimal -= entero;

        if (parteDecimal < 1e-9) {  // Agregado para evitar errores de redondeo
            parteDecimal = 0;
        }

        contador++;
    }

    return resultado;
}


string convertirDesdeBase10(double numero, int baseDeseada, int precision = presicion_decimales) {
    int parteEntera = static_cast<int>(numero);
    double parteDecimal = numero - parteEntera;

    string resultadoEntero = convertirEnteroDesdeBase10(parteEntera, baseDeseada);
    string resultadoDecimal = convertirDecimalDesdeBase10(parteDecimal, baseDeseada, precision);

    if (!resultadoDecimal.empty()) {
        return resultadoEntero + "." + resultadoDecimal;
    } else {
        return resultadoEntero;
    }
}

void dibujarMarco(int x, int y, int ancho, int alto);

void init(string numero, int baseActual, int baseDeseada, int opcion, int posBaseX, int posBaseY){
    ocultarCursor('T');
    while (true) {

        system("cls");  // Limpia la pantalla
        CALL_ME("C920An");
        mostrarHistorial(posBaseX + 65, posBaseY);
        // iniciar la intrf-----------------------------------------------------
        dibujarMarco(posBaseX - 2, posBaseY - 1, 65, 18);

        gotoxy(posBaseX + 10, posBaseY);
        cout << "Convertidor de bases numericas";

        gotoxy(posBaseX, posBaseY + 2);
        cout << "Ingrese la base actual: " << baseActual;
        gotoxy(posBaseX + 50, posBaseY + 2);
        if (opcion == 0) impTxtColor(" <- " , ClrCeleste); else cout<<"    ";

        gotoxy(posBaseX, posBaseY + 4);
        cout << "Ingrese la base a la que desea convertir: " << baseDeseada;
        gotoxy(posBaseX + 50, posBaseY + 4);
        if (opcion == 1) impTxtColor(" <- " , ClrCeleste); else cout<<"    ";

        gotoxy(posBaseX, posBaseY + 6);
        cout << "Ingrese el numero a convertir: " << numero;
        gotoxy(posBaseX + 50, posBaseY + 6);
        if (opcion == 2) impTxtColor(" <- " , ClrCeleste); else cout<<"    ";

        gotoxy(posBaseX + 20, posBaseY + 9);
        cout << "[Calcular]";
        gotoxy(posBaseX + 50, posBaseY + 9);
        if (opcion == 3) impTxtColor(" <- " , ClrCeleste); else cout<<"    ";

        char tecla = _getch();

        if (tecla == ARRIBA) {
            opcion = (opcion - 1 + 4) % 4;

        } else if (tecla == ABAJO) {
            opcion = (opcion + 1) % 4;

        } else if (tecla == ENTER) {

            ocultarCursor('F');

            if (opcion == 0) {
                gotoxy(posBaseX +24, posBaseY + 2);
                cout << string(20, ' ');  // Limpia la línea
                gotoxy(posBaseX +24, posBaseY + 2);
                string input;
                cin >> input;
                ocultarCursor('T');
                if (esNumerico(input)) {
                    int tempBase = stoi(input);
                    if (tempBase >= minBas && tempBase <= maxBas) {  //
                        baseActual = tempBase;
                    } else {
                        CALL_ME("Base fuera de rango (2-16). Se usará la base predeterminada 10.");
                        baseActual = 10;
                    }
                } else {
                    CALL_ME("Entrada no valida. Se usara el valor predeterminado 10.");
                    baseActual = 10;
                }

            } else if (opcion == 1) {
                gotoxy(posBaseX +42, posBaseY + 4);
                cout << string(20, ' ');  // Limpia la línea
                gotoxy(posBaseX + 42, posBaseY + 4);
                string input;
                cin >> input;
                ocultarCursor('T');
                if (esNumerico(input)) {
                    int tempBase = stoi(input);
                    if (tempBase >= minBas && tempBase <= maxBas) { //
                        baseDeseada = tempBase;
                    } else {
                        CALL_ME("Base fuera de rango (2-16). Se usara la base predeterminada 10.");
                        baseDeseada = 10;
                    }
                } else {
                    CALL_ME("Entrada no valida. Se usara el valor predeterminado 10.");
                    baseDeseada = 10;
                }

            } else if (opcion == 2) {



                gotoxy(posBaseX +31, posBaseY + 6);
                cout << string(20, ' ');
                gotoxy(posBaseX + 31, posBaseY + 6);
                cin >> numero;
                ocultarCursor('T');

                if (numero.length() > longNums) { //---------------
                    numero="0";
                    CALL_ME("Numero demasiado largo. Intente de nuevo.");
                }else if (!validarNumeroEnBase(numero, baseActual)) {
                    numero = "0";
                    CALL_ME("Numero invalido para la base " + to_string(baseActual) + ".");
                }



            } else if (opcion == 3) {

                double numeroDecimal = convertirABase10(numero, baseActual);
                string numeroConvertido = convertirDesdeBase10(numeroDecimal, baseDeseada);
                string resultado = numero + " en base " + to_string(baseActual)
                                   + " a base " + to_string(baseDeseada)
                                   + " es: " + numeroConvertido;
                agregarAlHistorial(resultado);
                gotoxy(posBaseX, posBaseY + 12);
                cout << resultado;
                mostrarHistorial(posBaseX + 65, posBaseY);

                ocultarCursor('T');

                _getch();  // Esperar q el usuario presione para continuar
            }
        }
    }
}


void dibujarMarco(int x, int y, int ancho, int alto) {


    for (int i = 0; i < ancho; ++i) {
        gotoxy(x + i, y);
        impTxtColor((i == 0 ? "+" : (i == ancho - 1 ? "+" : "-")), ClrCeleste);
        gotoxy(x + i, y + alto - 1);
        impTxtColor((i == 0 ? "+" : (i == ancho - 1 ? "+" : "-")), ClrCeleste);
    }

    // Dibujar los laterales
    for (int i = 1; i < alto - 1; ++i) {
        gotoxy(x, y + i);
        impTxtColor("|", ClrCeleste);
        gotoxy(x + ancho - 1, y + i);
        impTxtColor("|", ClrCeleste);
    }
}

int main() {
    string numero = "0";
    int baseActual = 10, baseDeseada = 10;
    int opcion = 0;
    int posBaseX = 8;
    int posBaseY = 2;
    init(numero, baseActual, baseDeseada, opcion, posBaseX, posBaseY);

    return 0;
}
