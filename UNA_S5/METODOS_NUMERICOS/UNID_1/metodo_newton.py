def newton_raphson(f, df, x0, tol=1e-6, max_iter=100):
    """
    Método de Newton-Raphson para encontrar una raíz de la función f.

    :param f: La función cuyo cero queremos encontrar.
    :param df: La derivada de la función f.
    :param x0: El valor inicial para la iteración.
    :param tol: La tolerancia para el criterio de convergencia.
    :param max_iter: El número máximo de iteraciones permitidas.
    :return: La raíz encontrada o None si no converge.
    """
    x = x0
    for i in range(max_iter):
        fx = f(x)
        dfx = df(x)
        
        if dfx == 0:
            print("La derivada es cero. El método no puede continuar.")
            return None
        
        x_new = x - fx / dfx
        
        if abs(x_new - x) < tol:
            print(f"Convergió después de {i+1} iteraciones.")
            return x_new
        
        x = x_new
    
    print("No convergió dentro del número máximo de iteraciones.")
    return None

# Ejemplo de uso:
# f(x) = x^2 - 2
# df(x) = 2x

def f(x):
    return x**2 - 2

def df(x):
    return 2*x

def f2(x):
    return math.sin(x)

def df2(x):
    return math.cos(x)

def f3(x):
    return math.exp(x) - 3

def df3(x):
    return math.exp(x)

x0 = 1.0  # Valor inicial
raiz = newton_raphson(f, df, x0)

if raiz is not None:
    print(f"Raíz encontrada: {raiz}")
