#include <iostream>
#include <cmath>

using namespace std;

double f(double x) {
    return x * x - 2;  // Función f(x) = x^2 - 2
}

double f_prime(double x) {
    return 2 * x;  // Derivada de f(x) = 2x
}

double newton_raphson(double x0, double tol, int max_iter) {
    double x = x0;
    for (int i = 0; i < max_iter; i++) {
        double fx = f(x);
        double fpx = f_prime(x);

        if (abs(fpx) < 1e-6) {  // Evita división por cero
            cout << "Derivada muy pequeña" << endl;
            break;
        }

        double x_new = x - fx / fpx;
        if (abs(x_new - x) < tol) {  // Verifica convergencia
            return x_new;
        }
        x = x_new;
    }
    return x;
}

int main() {
    double x0 = 1.0;  // Estimación inicial
    double tol = 1e-6;  // Tolerancia
    int max_iter = 100;  // Máximas iteraciones

    double raiz = newton_raphson(x0, tol, max_iter);
    cout << "La raíz aproximada es: " << raiz << endl;

    return 0;
}
