
import sympy as sp

def newton_raphson(f_sympy, x0, tol=1e-6, max_iter=100):
    """
    Método de Newton-Raphson utilizando SymPy para calcular la derivada automáticamente.

    :param f_sympy: La función simbólica de SymPy cuyo cero queremos encontrar.
    :param x0: El valor inicial para la iteración.
    :param tol: La tolerancia para el criterio de convergencia.
    :param max_iter: El número máximo de iteraciones permitidas.
    :return: La raíz encontrada o None si no converge.
    """
    x = sp.symbols('x')
    df_sympy = sp.diff(f_sympy, x)  # Calcula la derivada simbólica de f
    
    # Convierte las funciones simbólicas a funciones evaluables por Python
    f = sp.lambdify(x, f_sympy)
    df = sp.lambdify(x, df_sympy)

    x_curr = x0
    for i in range(max_iter):
        fx = f(x_curr)
        dfx = df(x_curr)
        
        if dfx == 0:
            print("La derivada es cero. El método no puede continuar.")
            return None
        
        x_new = x_curr - fx / dfx
        
        if abs(x_new - x_curr) < tol:
            print(f"Convergió después de {i+1} iteraciones.")
            return x_new
        
        x_curr = x_new
    
    print("No convergió dentro del número máximo de iteraciones.")
    return None

# Ejemplo de uso con SymPy
x = sp.symbols('x')
f_sympy = x**2 - 2  # Definimos la función simbólica

x0 = 1.0  # Valor inicial

raiz = newton_raphson(f_sympy, x0)

if raiz is not None:
    print(f"Raíz encontrada: {raiz}")
