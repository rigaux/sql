// Import de tous les packages JDBC
import java.sql.*;

// Une classe qui affiche les noms des voyageurs
class ListeVoyageurs {

	// Méthode "main", celle qui s'exécute quand on lance le programme
	public static void main(String args[]) throws SQLException {
		// Paramètres de connexion
		String url = "jdbc:mysql://localhost:3306/Voyageurs";
		String utilisateur = "moi";
		String motdepasse = "motdepasse";

		try {
			// Connection à la base
			Connection conn = DriverManager.getConnection(url, utilisateur, motdepasse);

			// Création d'un Statement,autrement dit un curseur
			Statement stmt = conn.createStatement();
			// Exécution de la requête qui ramène les voyageurs
			ResultSet rset = stmt.executeQuery("select * from Voyageur");

			// Affichage du résultat = parcours du curseur
			while (rset.next()) {
				System.out.println(rset.getString("prénom") + " " + rset.getString("nom"));
			}
			rset.close();
			stmt.close();
		} catch (SQLException e) {
			// Ousp, quelque chose s'est mal passé
			System.out.println("Problème quelque part !!!");
			System.out.println(e.getMessage());
		}
	}
}