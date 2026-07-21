import '../../../core/constants/app_assets.dart';
import '../domain/entities/barber.dart';
import '../domain/entities/barbershop.dart';
import '../domain/entities/review.dart';
import '../domain/entities/service.dart';

/// Realistic seed catalogue backing the mock repositories.
///
/// Data is deterministic so favorites, bookings and deep links stay stable
/// across sessions.
abstract final class ShopSeedData {
  static final List<Barbershop> shops = List.unmodifiable([
    _kingsCut,
    _gentlemansDen,
    _vintageGent,
    _classicCut,
    _urbanBlade,
    _velvetRazor,
    _fadeAndFellow,
    _northsideTrims,
    _aureliusGrooming,
  ]);

  static Service _svc(
    String shopId,
    int n,
    String name,
    int duration,
    double price,
    ServiceCategory category,
  ) =>
      Service(
        id: '$shopId-s$n',
        name: name,
        durationMin: duration,
        price: price,
        category: category,
      );

  static Barber _barber(
    String shopId,
    int n,
    String name,
    String specialty,
    double rating,
    int reviews,
  ) =>
      Barber(
        id: '$shopId-b$n',
        name: name,
        specialty: specialty,
        rating: rating,
        reviewCount: reviews,
      );

  static Review _review(
    String shopId,
    int n,
    String author,
    double rating,
    String text,
    int daysAgo,
  ) =>
      Review(
        id: '$shopId-r$n',
        author: author,
        rating: rating,
        text: text,
        date: DateTime.now().subtract(Duration(days: daysAgo)),
      );

  static final Barbershop _kingsCut = Barbershop(
    id: 'kings-cut',
    name: 'Kings Cut Lounge',
    address: '48 Crown Street, Midtown',
    neighborhood: 'Midtown',
    rating: 4.9,
    reviewCount: 214,
    distanceKm: 1.2,
    image: AppAssets.barbershopInterior,
    isOpen: true,
    services: [
      _svc('kings-cut', 1, 'Classic Cut', 45, 40, ServiceCategory.haircut),
      _svc('kings-cut', 2, 'Skin Fade', 50, 45, ServiceCategory.haircut),
      _svc('kings-cut', 3, 'Beard Trim', 30, 25, ServiceCategory.beard),
      _svc('kings-cut', 4, 'Hot Towel Shave', 40, 35, ServiceCategory.shave),
      _svc('kings-cut', 5, 'Grey Blending', 60, 55, ServiceCategory.coloring),
      _svc('kings-cut', 6, 'Head Massage', 20, 18, ServiceCategory.grooming),
      _svc('kings-cut', 7, 'Line Up', 20, 15, ServiceCategory.haircut),
    ],
    barbers: [
      _barber('kings-cut', 1, 'David Chen', 'Fade Specialist', 5.0, 124),
      _barber('kings-cut', 2, 'Sarah Miller', 'Beard Sculptor', 4.9, 98),
      _barber('kings-cut', 3, 'Marcus Reed', 'Classic Cuts', 4.8, 87),
      _barber('kings-cut', 4, 'Leo Grant', 'Razor Work', 4.7, 61),
    ],
    gallery: const [
      AppAssets.barbershopInterior,
      AppAssets.barberAtWork,
      AppAssets.barbershopInterior,
      AppAssets.barberAtWork,
      AppAssets.barbershopInterior,
      AppAssets.barberAtWork,
    ],
    reviews: [
      _review('kings-cut', 1, 'James Holt', 5,
          'Best fade I have had in years. David took his time with the detail work and the hot towel finish was a great touch.', 3),
      _review('kings-cut', 2, 'Omar Haddad', 5,
          'Walked in stressed, walked out feeling like royalty. The lounge atmosphere alone is worth the visit.', 9),
      _review('kings-cut', 3, 'Tom Becker', 4.5,
          'Great cut and easy booking. Slightly busy on Saturdays, so book ahead.', 16),
      _review('kings-cut', 4, 'Andre Silva', 5,
          'Sarah shaped my beard exactly how I asked. First shop where I did not need to explain twice.', 27),
    ],
  );

  static final Barbershop _gentlemansDen = Barbershop(
    id: 'gentlemans-den',
    name: "The Gentleman's Den",
    address: '12 Walnut Avenue, Old Town',
    neighborhood: 'Old Town',
    rating: 4.8,
    reviewCount: 187,
    distanceKm: 2.4,
    image: AppAssets.barberAtWork,
    isOpen: true,
    services: [
      _svc('gentlemans-den', 1, 'Signature Cut', 50, 48, ServiceCategory.haircut),
      _svc('gentlemans-den', 2, 'Beard Sculpt', 35, 30, ServiceCategory.beard),
      _svc('gentlemans-den', 3, 'Royal Shave', 45, 42, ServiceCategory.shave),
      _svc('gentlemans-den', 4, 'Full Color', 75, 70, ServiceCategory.coloring),
      _svc('gentlemans-den', 5, 'Kids Cut', 30, 24, ServiceCategory.haircut),
      _svc('gentlemans-den', 6, 'Scalp Treatment', 25, 22, ServiceCategory.grooming),
    ],
    barbers: [
      _barber('gentlemans-den', 1, 'Jameson Reed', 'Royal Shaves', 4.9, 142),
      _barber('gentlemans-den', 2, 'Elena Rojas', 'Precision Fades', 4.8, 96),
      _barber('gentlemans-den', 3, 'Hugo Lindqvist', 'Color Expert', 4.7, 58),
    ],
    gallery: const [
      AppAssets.barberAtWork,
      AppAssets.barbershopInterior,
      AppAssets.barberAtWork,
      AppAssets.barbershopInterior,
      AppAssets.barberAtWork,
      AppAssets.barbershopInterior,
    ],
    reviews: [
      _review('gentlemans-den', 1, 'Victor Nash', 5,
          'The royal shave is a ritual here — warm towels, cold stone finish, zero irritation. Absolutely worth it.', 5),
      _review('gentlemans-den', 2, 'Ben Okafor', 4.5,
          'Elena is a perfectionist with the clippers. My hairline has never looked this sharp.', 12),
      _review('gentlemans-den', 3, 'Charlie Munn', 5,
          'Brought my son for his first proper haircut. They made it a moment, not a chore.', 21),
    ],
  );

  static final Barbershop _vintageGent = Barbershop(
    id: 'vintage-gent',
    name: 'The Vintage Gent',
    address: '123 Grooming St, Downtown',
    neighborhood: 'Downtown',
    rating: 4.9,
    reviewCount: 128,
    distanceKm: 0.8,
    image: AppAssets.barbershopInterior,
    isOpen: true,
    services: [
      _svc('vintage-gent', 1, 'Classic Cut', 45, 40, ServiceCategory.haircut),
      _svc('vintage-gent', 2, 'Beard Trim', 30, 25, ServiceCategory.beard),
      _svc('vintage-gent', 3, 'Hot Towel Shave', 40, 35, ServiceCategory.shave),
      _svc('vintage-gent', 4, 'Pompadour Styling', 55, 50, ServiceCategory.haircut),
      _svc('vintage-gent', 5, 'Moustache Wax & Shape', 15, 12, ServiceCategory.beard),
      _svc('vintage-gent', 6, 'Camo Color', 45, 48, ServiceCategory.coloring),
      _svc('vintage-gent', 7, 'Face Cleanse', 25, 20, ServiceCategory.grooming),
      _svc('vintage-gent', 8, 'Buzz Cut', 20, 18, ServiceCategory.haircut),
    ],
    barbers: [
      _barber('vintage-gent', 1, 'Marcus Vance', 'Vintage Styles', 4.9, 117),
      _barber('vintage-gent', 2, 'Elena Ricci', 'Beard Design', 4.8, 84),
      _barber('vintage-gent', 3, 'Julian Sorel', 'Straight Razor', 4.9, 73),
      _barber('vintage-gent', 4, 'Leon Ashby', 'Modern Classics', 4.6, 39),
    ],
    gallery: const [
      AppAssets.barbershopInterior,
      AppAssets.barberAtWork,
      AppAssets.barbershopInterior,
      AppAssets.barberAtWork,
      AppAssets.barbershopInterior,
      AppAssets.barberAtWork,
    ],
    reviews: [
      _review('vintage-gent', 1, 'Paul Whitmore', 5,
          'Feels like stepping into another era — leather chairs, jazz, and a barber who actually listens.', 2),
      _review('vintage-gent', 2, 'Danny Cortez', 5,
          'Julian\'s straight razor work is surgical. Closest shave of my life.', 8),
      _review('vintage-gent', 3, 'Mike Trent', 4.5,
          'Pompadour came out exactly like the reference photo. Booking again next month.', 15),
      _review('vintage-gent', 4, 'Aaron Feld', 5,
          'Great attention to detail and they never rush you out of the chair.', 30),
      _review('vintage-gent', 5, 'Stefan Krebs', 4.5,
          'Solid cut, fair price for downtown. The face cleanse add-on is underrated.', 41),
    ],
  );

  static final Barbershop _classicCut = Barbershop(
    id: 'classic-cut',
    name: 'The Classic Cut',
    address: '87 Mercer Lane, Manhattan',
    neighborhood: 'Manhattan',
    rating: 4.9,
    reviewCount: 203,
    distanceKm: 1.2,
    image: AppAssets.barbershopInterior,
    isOpen: true,
    services: [
      _svc('classic-cut', 1, 'Gentleman\'s Cut', 45, 42, ServiceCategory.haircut),
      _svc('classic-cut', 2, 'Fade & Taper', 50, 46, ServiceCategory.haircut),
      _svc('classic-cut', 3, 'Beard Detailing', 30, 26, ServiceCategory.beard),
      _svc('classic-cut', 4, 'Traditional Shave', 40, 36, ServiceCategory.shave),
      _svc('classic-cut', 5, 'Silver Fox Toning', 55, 52, ServiceCategory.coloring),
      _svc('classic-cut', 6, 'Eyebrow Tidy', 10, 10, ServiceCategory.grooming),
    ],
    barbers: [
      _barber('classic-cut', 1, 'Anthony Russo', 'Tapers & Fades', 5.0, 156),
      _barber('classic-cut', 2, 'Grace Lin', 'Scissor Work', 4.9, 102),
      _barber('classic-cut', 3, 'Sam Whitaker', 'Beard Craft', 4.7, 66),
    ],
    gallery: const [
      AppAssets.barbershopInterior,
      AppAssets.barberAtWork,
      AppAssets.barbershopInterior,
      AppAssets.barberAtWork,
      AppAssets.barbershopInterior,
      AppAssets.barberAtWork,
    ],
    reviews: [
      _review('classic-cut', 1, 'Robert Kane', 5,
          'Anthony has cut my hair for a year now — consistent, sharp, and always on time.', 4),
      _review('classic-cut', 2, 'Felix Moreau', 5,
          'The taper fade is immaculate. You can tell everyone here takes pride in the craft.', 11),
      _review('classic-cut', 3, 'Ivan Petrov', 4.5,
          'Clean shop, friendly team, and the eyebrow tidy is a nice finishing touch.', 19),
      _review('classic-cut', 4, 'Noel Adams', 5,
          'Grace understood exactly what I wanted from one photo. Rare skill.', 33),
    ],
  );

  static final Barbershop _urbanBlade = Barbershop(
    id: 'urban-blade',
    name: 'Urban Blade Studio',
    address: '5 Foundry Row, Riverside',
    neighborhood: 'Riverside',
    rating: 4.7,
    reviewCount: 156,
    distanceKm: 0.8,
    image: AppAssets.barberAtWork,
    isOpen: true,
    services: [
      _svc('urban-blade', 1, 'Studio Cut', 40, 38, ServiceCategory.haircut),
      _svc('urban-blade', 2, 'Skin Fade', 45, 42, ServiceCategory.haircut),
      _svc('urban-blade', 3, 'Beard Line-Up', 25, 20, ServiceCategory.beard),
      _svc('urban-blade', 4, 'Clean Shave', 30, 28, ServiceCategory.shave),
      _svc('urban-blade', 5, 'Platinum Bleach', 90, 85, ServiceCategory.coloring),
      _svc('urban-blade', 6, 'Design Lines', 20, 18, ServiceCategory.haircut),
      _svc('urban-blade', 7, 'Black Mask Facial', 30, 26, ServiceCategory.grooming),
    ],
    barbers: [
      _barber('urban-blade', 1, 'Kai Nakamura', 'Design Lines', 4.8, 91),
      _barber('urban-blade', 2, 'Tyler Brooks', 'Skin Fades', 4.7, 77),
      _barber('urban-blade', 3, 'Zoe Carter', 'Color & Bleach', 4.6, 49),
    ],
    gallery: const [
      AppAssets.barberAtWork,
      AppAssets.barbershopInterior,
      AppAssets.barberAtWork,
      AppAssets.barbershopInterior,
      AppAssets.barberAtWork,
      AppAssets.barbershopInterior,
    ],
    reviews: [
      _review('urban-blade', 1, 'Dre Wallace', 5,
          'Kai freestyled a design on the side that gets me compliments daily. Real artist.', 6),
      _review('urban-blade', 2, 'Lucas Meyer', 4.5,
          'Modern shop with great music and quick service. Fade game is strong.', 13),
      _review('urban-blade', 3, 'Josh Pine', 4,
          'Good cut for the price. Gets loud at peak hours but the quality holds up.', 24),
    ],
  );

  static final Barbershop _velvetRazor = Barbershop(
    id: 'velvet-razor',
    name: 'Velvet Razor Club',
    address: '221 Amber Court, Uptown',
    neighborhood: 'Uptown',
    rating: 4.8,
    reviewCount: 174,
    distanceKm: 3.1,
    image: AppAssets.barbershopInterior,
    isOpen: false,
    services: [
      _svc('velvet-razor', 1, 'Club Cut', 50, 52, ServiceCategory.haircut),
      _svc('velvet-razor', 2, 'Luxury Hot Towel Shave', 50, 45, ServiceCategory.shave),
      _svc('velvet-razor', 3, 'Beard Ritual', 40, 34, ServiceCategory.beard),
      _svc('velvet-razor', 4, 'Charcoal Detox', 35, 30, ServiceCategory.grooming),
      _svc('velvet-razor', 5, 'Tonal Color Melt', 80, 78, ServiceCategory.coloring),
      _svc('velvet-razor', 6, 'Executive Trim', 30, 32, ServiceCategory.haircut),
    ],
    barbers: [
      _barber('velvet-razor', 1, 'Elias Thorne', 'Luxury Shaves', 4.9, 133),
      _barber('velvet-razor', 2, 'Nina Volkov', 'Color Melts', 4.8, 71),
      _barber('velvet-razor', 3, 'Owen Blake', 'Executive Cuts', 4.7, 54),
      _barber('velvet-razor', 4, 'Ray Donovan', 'Beard Rituals', 4.6, 47),
    ],
    gallery: const [
      AppAssets.barbershopInterior,
      AppAssets.barberAtWork,
      AppAssets.barbershopInterior,
      AppAssets.barberAtWork,
      AppAssets.barbershopInterior,
      AppAssets.barberAtWork,
    ],
    reviews: [
      _review('velvet-razor', 1, 'Gerald Foss', 5,
          'The beard ritual with warm oils is an experience, not just a trim. Elias is a master.', 7),
      _review('velvet-razor', 2, 'Martin Hale', 5,
          'Members-club feel without the attitude. Impeccable service every single visit.', 18),
      _review('velvet-razor', 3, 'Chris Yoon', 4.5,
          'Pricey, but you get what you pay for. The hot towel shave is the best uptown.', 29),
    ],
  );

  static final Barbershop _fadeAndFellow = Barbershop(
    id: 'fade-fellow',
    name: 'Fade & Fellow',
    address: '9 Cooper Yard, Eastside',
    neighborhood: 'Eastside',
    rating: 4.6,
    reviewCount: 98,
    distanceKm: 4.5,
    image: AppAssets.barberAtWork,
    isOpen: true,
    services: [
      _svc('fade-fellow', 1, 'House Fade', 40, 32, ServiceCategory.haircut),
      _svc('fade-fellow', 2, 'Scissor Crop', 35, 30, ServiceCategory.haircut),
      _svc('fade-fellow', 3, 'Beard Shape-Up', 25, 18, ServiceCategory.beard),
      _svc('fade-fellow', 4, 'Steam Shave', 35, 26, ServiceCategory.shave),
      _svc('fade-fellow', 5, 'Kids Fade', 30, 22, ServiceCategory.haircut),
    ],
    barbers: [
      _barber('fade-fellow', 1, 'Danny Alvarez', 'House Fades', 4.7, 63),
      _barber('fade-fellow', 2, 'Pete Kowalski', 'Scissor Crops', 4.6, 44),
      _barber('fade-fellow', 3, 'Ash Turner', 'Kids Cuts', 4.5, 31),
    ],
    gallery: const [
      AppAssets.barberAtWork,
      AppAssets.barbershopInterior,
      AppAssets.barberAtWork,
      AppAssets.barbershopInterior,
      AppAssets.barberAtWork,
      AppAssets.barbershopInterior,
    ],
    reviews: [
      _review('fade-fellow', 1, 'Kevin Roy', 5,
          'Neighborhood gem. Danny remembers exactly how I like my fade every time.', 10),
      _review('fade-fellow', 2, 'Sean Duffy', 4.5,
          'Honest prices and zero pretension. My kid actually looks forward to haircuts now.', 22),
      _review('fade-fellow', 3, 'Marco Bianchi', 4,
          'Reliable walk-in spot. Weekends fill up fast, so use the app.', 35),
    ],
  );

  static final Barbershop _northsideTrims = Barbershop(
    id: 'northside-trims',
    name: 'Northside Trims',
    address: '310 Birch Boulevard, Northside',
    neighborhood: 'Northside',
    rating: 4.5,
    reviewCount: 87,
    distanceKm: 5.9,
    image: AppAssets.barbershopInterior,
    isOpen: true,
    services: [
      _svc('northside-trims', 1, 'Standard Cut', 35, 28, ServiceCategory.haircut),
      _svc('northside-trims', 2, 'Buzz & Shape', 20, 16, ServiceCategory.haircut),
      _svc('northside-trims', 3, 'Beard Tidy', 20, 15, ServiceCategory.beard),
      _svc('northside-trims', 4, 'Classic Shave', 30, 24, ServiceCategory.shave),
      _svc('northside-trims', 5, 'Grey Coverage', 50, 44, ServiceCategory.coloring),
      _svc('northside-trims', 6, 'Neck Cleanup', 10, 8, ServiceCategory.grooming),
    ],
    barbers: [
      _barber('northside-trims', 1, 'Bill Hartman', 'Classic Cuts', 4.6, 52),
      _barber('northside-trims', 2, 'Jo Reyes', 'Quick Trims', 4.5, 38),
      _barber('northside-trims', 3, 'Curtis Lowe', 'Shaves', 4.4, 26),
    ],
    gallery: const [
      AppAssets.barbershopInterior,
      AppAssets.barberAtWork,
      AppAssets.barbershopInterior,
      AppAssets.barberAtWork,
      AppAssets.barbershopInterior,
      AppAssets.barberAtWork,
    ],
    reviews: [
      _review('northside-trims', 1, 'Harold Weiss', 4.5,
          'No-nonsense barbershop that gets it right. In and out in forty minutes.', 8),
      _review('northside-trims', 2, 'Glen Parker', 4.5,
          'Bill has been cutting hair for twenty years and it shows.', 17),
      _review('northside-trims', 3, 'Tony Marsh', 4,
          'Good value for the northside. Parking is easy, which is half the battle.', 26),
    ],
  );

  static final Barbershop _aureliusGrooming = Barbershop(
    id: 'aurelius',
    name: 'Aurelius Grooming Co.',
    address: '77 Laurel Steps, Hillcrest',
    neighborhood: 'Hillcrest',
    rating: 4.8,
    reviewCount: 141,
    distanceKm: 2.0,
    image: AppAssets.barberAtWork,
    isOpen: true,
    services: [
      _svc('aurelius', 1, 'Precision Cut', 55, 50, ServiceCategory.haircut),
      _svc('aurelius', 2, 'Beard Architecture', 40, 35, ServiceCategory.beard),
      _svc('aurelius', 3, 'Imperial Shave', 45, 40, ServiceCategory.shave),
      _svc('aurelius', 4, 'Texture Perm', 90, 88, ServiceCategory.haircut),
      _svc('aurelius', 5, 'Root Shadow', 60, 58, ServiceCategory.coloring),
      _svc('aurelius', 6, 'Gold Facial', 40, 38, ServiceCategory.grooming),
      _svc('aurelius', 7, 'Express Trim', 25, 24, ServiceCategory.haircut),
    ],
    barbers: [
      _barber('aurelius', 1, 'Adrian Vasquez', 'Precision Cuts', 4.9, 108),
      _barber('aurelius', 2, 'Mia Sandoval', 'Texture & Perms', 4.8, 79),
      _barber('aurelius', 3, 'Noah Sterling', 'Beard Architecture', 4.7, 63),
      _barber('aurelius', 4, 'Iris Chen', 'Color Design', 4.8, 55),
    ],
    gallery: const [
      AppAssets.barberAtWork,
      AppAssets.barbershopInterior,
      AppAssets.barberAtWork,
      AppAssets.barbershopInterior,
      AppAssets.barberAtWork,
      AppAssets.barbershopInterior,
    ],
    reviews: [
      _review('aurelius', 1, 'Damian Cole', 5,
          'Adrian measures twice and cuts once. The most precise haircut I have ever received.', 5),
      _review('aurelius', 2, 'Ray Chen', 5,
          'The gold facial sounds like a gimmick — it is not. Skin felt incredible for a week.', 14),
      _review('aurelius', 3, 'Evan Ross', 4.5,
          'Beautiful studio and a genuinely warm team. The texture perm changed my routine.', 23),
      _review('aurelius', 4, 'Zach Ellison', 4.5,
          'Booked an express trim on my lunch break. Sharp result, right on schedule.', 37),
    ],
  );
}
