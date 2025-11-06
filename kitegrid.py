import math
from typing import List, Tuple
import matplotlib.pyplot as plt
from matplotlib.patches import Polygon
from matplotlib.collections import LineCollection
import numpy as np

Point = Tuple[int, int]
PointF = Tuple[float, float]

class KiteGrid:
    # Tile types (6 orientations)
    KITE_E, KITE_NE, KITE_NW, KITE_W, KITE_SW, KITE_SE = range(6)
    INVALID = -1

    # Origins of each kite type
    origins: List[Point] = [
        (1, 0), (0, 1), (-1, 1),
        (-1, 0), (0, -1), (1, -1)
    ]

    # Tile vertices (integer offsets relative to origin)
    tile_vertices: List[List[Point]] = [
        [(0, 0), (2, -1), (2, 0), (1, 1)],        # E
        [(0, 0), (1, 1), (0, 2), (-1, 2)],        # NE
        [(0, 0), (-1, 2), (-2, 2), (-2, 1)],      # NW
        [(0, 0), (-2, 1), (-2, 0), (-1, -1)],     # W
        [(0, 0), (-1, -1), (0, -2), (1, -2)],     # SW
        [(0, 0), (1, -2), (2, -2), (2, -1)],      # SE
    ]

    # Edge neighbor offsets for each kite type
    edge_neighbours: List[List[Point]] = [
        [(1,1), (2,-1), (-1,1), (0,-1)],
        [(-1,2), (1,1), (-1,0), (1,-1)],
        [(-2,1), (-1,2), (0,-1), (1,0)],
        [(-1,-1), (-2,1), (1,-1), (0,1)],
        [(1,-2), (-1,-1), (1,0), (-1,1)],
        [(2,-1), (1,-2), (0,1), (-1,0)],
    ]

    # All neighbor offsets for each kite type
    all_neighbours: List[List[Point]] = [
    [ # east
        ( 1, 1 ),
        ( 2, -1 ),
        ( -1, 1 ),
        ( 0, -1 ),
        ( 0, 2 ),
        ( 2, -2 ),
        ( -2, 0 ),
        ( -2, 1 ),
        ( -1, -1 )
    ],
    [ # northeast
        ( -1, 2 ),
        ( 1, 1 ),
        ( -1, 0 ),
        ( 1, -1 ),
        ( -2, 2 ),
        ( 2, 0 ),
        ( 0, -2 ),
        ( -1, -1 ),
        ( 1, -2 )
    ],
    [ # northwest
        ( -2, 1 ),
        ( -1, 2 ),
        ( 0, -1 ),
        ( 1, 0 ),
        ( -2, 0 ),
        ( 0, 2 ),
        ( 2, -2 ),
        ( 1, -2 ),
        ( 2, -1 )
    ],
    [ # west
        ( -1, -1 ),
        ( -2, 1 ),
        ( 1, -1 ),
        ( 0, 1 ),
        ( 0, -2 ),
        ( -2, 2 ),
        ( 2, 0 ),
        ( 2, -1 ),
        ( 1, 1 )
    ],
    [ # southwest
        ( 1, -2 ),
        ( -1, -1 ),
        ( 1, 0 ),
        ( -1, 1 ),
        ( 2, -2 ),
        ( -2, 0 ),
        ( 0, 2 ),
        ( 1, 1 ),
        ( -1, 2 )
    ],
    [ # southeast
        ( 2, -1 ),
        ( 1, -2 ),
        ( 0, 1 ),
        ( -1, 0 ),
        ( 2, 0 ),
        ( 0, -2 ),
        ( -2, 2 ),
        ( -1, 2 ),
        ( -2, 1 )
    ]       
    ]

    # Translation vectors
    translationV1: Point = (4, -2)
    translationV2: Point = (2, 2)

    # Lookup table for tile orientations in 6x6 parallelogram
    tile_orientations: List[int] = [
        7, 0, 7, 7, 7, 3,
        1, 7, 4, 5, 7, 2,
        7, 3, 7, 0, 7, 7,
        7, 2, 1, 7, 4, 5,
        7, 7, 7, 3, 7, 0,
        4, 5, 7, 2, 1, 7
    ]

    @staticmethod
    def get_tile_orientation(p: Point) -> int:
        x, y = p
        idx = ((y % 6) * 6 + (x % 6)) % 36
        return KiteGrid.tile_orientations[idx]

    @staticmethod
    def get_origin(p: Point) -> Point:
        ori = KiteGrid.get_tile_orientation(p)
        if ori == 7:
            return (0, 0)
        return KiteGrid.origins[ori]
    
    @staticmethod
    def translatable(p: Point, q: Point) -> bool:
        px, py = p
        qx, qy = q
        c = qx - px
        d = qy - py
        return (d%2) == 0 and (c-d)%6 == 0
 
    @staticmethod
    def get_cell_vertices(p: Point) -> List[Point]:
        ori = KiteGrid.get_tile_orientation(p)
        if ori == 7:
            return []
        ox, oy = KiteGrid.get_origin(p)
        cx, cy = p[0] - ox, p[1] - oy
        return [(cx + vx, cy + vy) for (vx, vy) in KiteGrid.tile_vertices[ori]]

    @staticmethod
    def grid_to_cartesian(p: PointF) -> PointF:
        """Convert grid coordinates to Cartesian coordinates for drawing."""
        x, y = p
        return (x + 0.5 * y, 0.5 * math.sqrt(3) * y)

    @staticmethod
    def vertex_to_grid(p: Point) -> PointF:
        """Map vertex coordinates to grid coordinates (identity in this simple version)."""
        return (float(p[0]), float(p[1]))

    @staticmethod
    def get_neighbour_vectors(p: Point) -> List[Point]:
        return KiteGrid.all_neighbours[KiteGrid.get_tile_orientation(p)]
    
    @staticmethod
    def get_edge_neighbour_vectors(p: Point) -> List[Point]:
        return KiteGrid.edge_neighbours[KiteGrid.get_tile_orientation(p)]
    
    @staticmethod
    def halo(S: List[Point]) -> List[Point]:
        """Return the halo of shape S"""
        halo = []
        for p in S:
            neighbourhood_of_p = KiteGrid.get_neighbour_vectors(p)
            halo += [tuple(np.array(p) + np.array(neighbour)) for neighbour in neighbourhood_of_p]
        halo = {p for p in halo if p not in S}

        return list(halo)
    
    @staticmethod
    def edge_halo(S: List[Point]) -> set:
        halo = set()
        for p in S:
            for dv in KiteGrid.get_edge_neighbour_vectors(p):
                halo.add((p[0] + dv[0], p[1] + dv[1]))
        return halo - set(S)
    
    @staticmethod
    def adjacent(S: List[Point], R: List[Point]) -> bool:
        """Check if two shapes are adjacent"""
        return set(S).intersection(set(R)) == set() and set(S).intersection(set(KiteGrid.halo(R))) != set()
    
    @staticmethod
    def edge_adjacent(S: List[Point], R: List[Point]) -> bool:
        """Check if two shapes are adjacent"""
        return set(S).intersection(set(R)) == set() and set(S).intersection(set(KiteGrid.edge_halo(R))) != set()
    
def edge_key(a, b):
    """Return a canonical representation of an edge (unordered pair)."""
    return tuple(sorted([a, b]))

def draw_kite_grid(Ni: int, Nj: int, show_labels: bool = True):
    """
    Draw a kite grid with Ni columns and Nj rows.
    Optionally show lattice coordinates (i, j) at each kite centroid.
    """
    fig, ax = plt.subplots(figsize=(10, 10))

    for i in range(-Ni, Ni):
        for j in range(-Nj, Nj):
            p = (i, j)

            # Get vertices of kite
            vertices = KiteGrid.get_cell_vertices(p)
            if not vertices:
                continue  # skip invalid tiles

            # Convert to Cartesian coordinates
            cart_vertices = [KiteGrid.grid_to_cartesian(v) for v in vertices]

            # Draw kite polygon
            kite = Polygon(
                cart_vertices,
                closed=True,
                edgecolor='black',
                facecolor='white',
                linewidth=0.8
            )
            ax.add_patch(kite)

            # Optionally show the (i, j) grid coordinates
            if show_labels: #and KiteGrid.get_tile_orientation(p) == 0:
                # Compute centroid (average of vertices)
                cx = sum(x for x, _ in cart_vertices) / len(cart_vertices)
                cy = sum(y for _, y in cart_vertices) / len(cart_vertices)

                ax.text(
                    cx,
                    cy,
                    f"({i},{j})",
                    ha='center',
                    va='center',
                    fontsize=6,
                    color='gray'
                )

    # Formatting
    ax.set_aspect('equal')
    max_x = Ni + 0.5 * Nj
    max_y = 0.5 * math.sqrt(3) * Nj
    ax.set_xlim(-max_x - 1, max_x + 1)
    ax.set_ylim(-max_y - 1, max_y + 1)
    ax.axis('off')

    return fig, ax


def draw_hat(ax,hat,colour='lightgrey'):
    edges = {}
        
    # Step 1: Collect edges of all hat kites
    for p in hat:
        vertices = KiteGrid.get_cell_vertices(p)
        cart_vertices = [KiteGrid.grid_to_cartesian(v) for v in vertices]
        
        # Make sure the polygon is closed
        cart_vertices.append(cart_vertices[0])
        for c, d in zip(cart_vertices[:-1], cart_vertices[1:]):
            key = edge_key(c, d)
            edges[key] = edges.get(key, 0) + 1
    
    # Step 2: Keep only boundary edges (appear once)
    boundary_edges = [edge for edge, count in edges.items() if count == 1]
    
    # Step 3: Draw the boundary
    lc = LineCollection(boundary_edges, colors='black', linewidths=2)
    ax.add_collection(lc)

    ordered = [boundary_edges[0][0], boundary_edges[0][1]]
    edges_left = boundary_edges[1:]

    while edges_left:
        last = ordered[-1]
        found = False
        for i, (a, b) in enumerate(edges_left):
            if a == last:
                ordered.append(b)
                edges_left.pop(i)
                found = True
                break
            elif b == last:
                ordered.append(a)
                edges_left.pop(i)
                found = True
                break
        if not found:
            break

    # Step 4: Draw filled polygon
    poly = Polygon(ordered, closed=True, facecolor=colour, alpha=0.5, lw=2)
    ax.add_patch(poly)

