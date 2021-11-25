create table restaurant(
  id integer,
  name varchar(20),
  description varchar(100),
  rating decimal,
  telephone char(10),
  hours varchar(100)
);

 create table address(
   id integer,
   street_number varchar(10),
   street_name varchar(20),
   city varchar(20),
   state varchar(15),
   google_map_link varchar(50)
 );

 alter table restaurant
 add primary key (id);

 alter table address
 add primary key (id);

select constraint_name, table_name, column_name
from information_schema.key_column_usage
where table_name = 'restaurant' or table_name = 'address';

create table category (
  id char(2) primary key,
  name varchar(20),
  description varchar(200)
);

create table dish (
  id integer primary key,
  name varchar(50),
  description varchar(200),
  hot_and_spicy boolean
);

create table review  (
  id integer primary key,
  rating decimal,
  description varchar(200),
  date date
);

alter table address
add column restaurant_id  integer references restaurant(id) unique ;

alter table review
add column restaurant_id integer references restaurant(id);



-- select constraint_name, table_name, column_name
-- from information_schema.key_column_usage;

create table categories_dishes(
  category_id char(2) references category(id),
  dish_id integer references dish(id),
  price money,
  primary key (category_id, dish_id)
);


select constraint_name, table_name, column_name
from information_schema.key_column_usage
where table_name = 'categories_dishes';

/*
 *--------------------------------------------
 Insert values for restaurant
 *--------------------------------------------
 */
INSERT INTO restaurant VALUES (
  1,
  'Bytes of China',
  'Delectable Chinese Cuisine',
  3.9,
  '6175551212',
  'Mon - Fri 9:00 am to 9:00 pm, Weekends 10:00 am to 11:00 pm'
);

/*
 *--------------------------------------------
 Insert values for address
 *--------------------------------------------
 */
INSERT INTO address VALUES (
  1,
  '2020',
  'Busy Street',
  'Chinatown',
  'MA',
  'http://bit.ly/BytesOfChina',
  1
);

/*
 *--------------------------------------------
 Insert values for review
 *--------------------------------------------
 */
INSERT INTO review VALUES (
  1,
  5.0,
  'Would love to host another birthday party at Bytes of China!',
  '05-22-2020',
  1
);

INSERT INTO review VALUES (
  2,
  4.5,
  'Other than a small mix-up, I would give it a 5.0!',
  '04-01-2020',
  1
);

INSERT INTO review VALUES (
  3,
  3.9,
  'A reasonable place to eat for lunch, if you are in a rush!',
  '03-15-2020',
  1
);

/*
 *--------------------------------------------
 Insert values for category
 *--------------------------------------------
 */
INSERT INTO category VALUES (
  'C',
  'Chicken',
  null
);

INSERT INTO category VALUES (
  'LS',
  'Luncheon Specials',
  'Served with Hot and Sour Soup or Egg Drop Soup and Fried or Steamed Rice  between 11:00 am and 3:00 pm from Monday to Friday.'
);

INSERT INTO category VALUES (
  'HS',
  'House Specials',
  null
);

/*
 *--------------------------------------------
 Insert values for dish
 *--------------------------------------------
 */
INSERT INTO dish VALUES (
  1,
  'Chicken with Broccoli',
  'Diced chicken stir-fried with succulent broccoli florets',
  false
);

INSERT INTO dish VALUES (
  2,
  'Sweet and Sour Chicken',
  'Marinated chicken with tangy sweet and sour sauce together with pineapples and green peppers',
  false
);

INSERT INTO dish VALUES (
  3,
  'Chicken Wings',
  'Finger-licking mouth-watering entree to spice up any lunch or dinner',
  true
);

INSERT INTO dish VALUES (
  4,
  'Beef with Garlic Sauce',
  'Sliced beef steak marinated in garlic sauce for that tangy flavor',
  true
);

INSERT INTO dish VALUES (
  5,
  'Fresh Mushroom with Snow Peapods and Baby Corns',
  'Colorful entree perfect for vegetarians and mushroom lovers',
  false
);

INSERT INTO dish VALUES (
  6,
  'Sesame Chicken',
  'Crispy chunks of chicken flavored with savory sesame sauce',
  false
);

INSERT INTO dish VALUES (
  7,
  'Special Minced Chicken',
  'Marinated chicken breast sauteed with colorful vegetables topped with pine nuts and shredded lettuce.',
  false
);

INSERT INTO dish VALUES (
  8,
  'Hunan Special Half & Half',
  'Shredded beef in Peking sauce and shredded chicken in garlic sauce',
  true
);

/*
 *--------------------------------------------
 Insert valus for cross-reference table, categories_dishes
 *--------------------------------------------
 */
INSERT INTO categories_dishes VALUES (
  'C',
  1,
  6.95
);

INSERT INTO categories_dishes VALUES (
  'C',
  3,
  6.95
);

INSERT INTO categories_dishes VALUES (
  'LS',
  1,
  8.95
);

INSERT INTO categories_dishes VALUES (
  'LS',
  4,
  8.95
);

INSERT INTO categories_dishes VALUES (
  'LS',
  5,
  8.95
);

INSERT INTO categories_dishes VALUES (
  'HS',
  6,
  15.95
);

INSERT INTO categories_dishes VALUES (
  'HS',
  7,
  16.95
);

INSERT INTO categories_dishes VALUES (
  'HS',
  8,
  17.95
);

select restaurant.name, street_number, telephone
from restaurant
join address
on restaurant.id = restaurant_id;

select max(rating) as best_rating from review;

with temp_table as (
  select name as dish_name, price, category_id
from dish
join categories_dishes
on dish.id = dish_id
)
select dish_name, price, category.name as category
from temp_table
join category
on category.id = category_id
order by dish_name;

with temp_table as (
  select name as dish_name, price, category_id
from dish
join categories_dishes
on dish.id = dish_id
)
select  category.name as category, dish_name, price
from temp_table
join category
on category.id = category_id
order by category;

with temp_table as (
  select name as spicy_dish_name, price, category_id
from dish
join categories_dishes
on dish.id = dish_id
where hot_and_spicy = true
)
select spicy_dish_name, category.name as category,  price
from temp_table
join category
on category.id = category_id
order by category;

select dish_id, count(dish_id) as dish_count
from categories_dishes
group by 1;

select dish.name as dish_name, count(dish_id) as dish_count
from categories_dishes
join dish
on dish.id = dish_id
group by 1
having count(dish_id) > 1;

SELECT rating as best_rating, description
FROM review
WHERE  rating = ( SELECT MAX(rating) from review );
