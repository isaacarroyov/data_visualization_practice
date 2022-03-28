import numpy as np 
import matplotlib.pyplot as plt

# Parametric curve
t = np.linspace( -0.25, 2.35, 100 )
X_curve = t
Y_curve = 5*( (t - 2)**2 ) + 2*( (t - 2)**3 )

# Derivative of the curve
U_dcurve = 1
V_dcurve = 4 - 14*t + 6*(t**2)

# Vector field
# Non in curve
x = np.linspace(-1, 2.5, 25)
y = np.linspace(-1, 5, 25)
x,y = np.meshgrid(x,y)
u = np.sin(x)
v = np.cos(y)
mag = np.sqrt(u**2 + v**2)

# In curve
U = np.sin(X_curve)
V = np.cos(Y_curve)
Magnitude = np.sqrt(U**2 + V**2)

fig, ((ax1,ax2),(ax3,ax4)) = plt.subplots(figsize=(1920/300,1920/300), ncols=2, nrows=2,
                      facecolor = '#FFFCF3',
                      dpi=150
)
ax1.axis("off")
ax2.axis("off")
ax3.axis("off")
ax4.axis("off")

# Upper left
ax1.quiver(X_curve, Y_curve, U_dcurve, V_dcurve,
          width = 0.0025, headwidth = 3, headlength = 4,
          color = '#872108')
ax1.plot( X_curve, Y_curve, lw = 1.25, color = '#F24318')


# Upper right
ax2.quiver( x, y, u, v, mag,
           width = 0.002, headwidth = 4, headlength = 4,
           cmap = plt.cm.PuBuGn)


# Lower left
ax3.quiver( x, y, u, v, mag,
           width = 0.002, headwidth = 4, headlength = 4,
           cmap = plt.cm.PuBuGn)
ax3.quiver(X_curve, Y_curve, U_dcurve, V_dcurve,
          width = 0.0025, headwidth = 3, headlength = 4,
          color = '#872108')
ax3.plot( X_curve, Y_curve, lw = 1.25, color = '#F24318')


# Lower right
ax4.quiver( X_curve, Y_curve, U, V, Magnitude,
           width = 0.002, headwidth = 4, headlength = 4,
           cmap = plt.cm.PuBuGn)
ax4.quiver(X_curve, Y_curve, U_dcurve, V_dcurve,
          width = 0.0025, headwidth = 3, headlength = 4,
          color = '#872108')
ax4.plot( X_curve, Y_curve, lw = 1.25, color = '#F24318')


# Limits
ax1.set_xlim(-0.28,2.4)
ax2.set_xlim(-0.28,2.4)
ax3.set_xlim(-0.28,2.4)
ax4.set_xlim(-0.28,2.4)

ax1.set_ylim(-0.05,4.7)
ax2.set_ylim(-0.05,4.7)
ax3.set_ylim(-0.05,4.7)
ax4.set_ylim(-0.05,4.7)

plt.show()