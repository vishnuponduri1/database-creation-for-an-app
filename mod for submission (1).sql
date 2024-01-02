SELECT * FROM mod_gp.t1;
-- Query 1
SELECT 
    T.Temple_Name,
    State,
    TR.Station_Name,
    TR.Transport_Type,
    (6371 * ACOS(COS(RADIANS(T.latitude)) * COS(RADIANS(TR.latitude)) * COS(RADIANS(TR.longitude) - RADIANS(T.longitude)) + SIN(RADIANS(T.latitude)) * SIN(RADIANS(TR.latitude)))) AS distancekms
FROM
    Temple T
        INNER JOIN
    temple_transport TT ON T.Temple_ID = TT.Temple_ID
        INNER JOIN
    Transport TR ON TR.Transport_ID = TT.Transport_ID
WHERE
    T.Temple_Name = 'Akshardham Temple '
        AND State = 'Delhi'
        AND (6371 * ACOS(COS(RADIANS(T.latitude)) * COS(RADIANS(TR.latitude)) * COS(RADIANS(TR.longitude) - RADIANS(T.longitude)) + SIN(RADIANS(T.latitude)) * SIN(RADIANS(TR.latitude)))) < 7
ORDER BY distancekms;

-- Query 2
SELECT 
    T.Temple_Name, G.God_Name, T.City
FROM
    Temple T
        INNER JOIN
    God_Temple GT ON T.Temple_ID = GT.Temple_ID
        INNER JOIN
    God G ON G.God_ID = GT.God_ID
WHERE
    G.God_Name = 'Lord Shiva'
        AND T.City IN ('Bhubaneshwar' , 'Kedarnath', 'Srisailam');
        
        -- Query 03
SELECT 
    Transport_Type,
    COUNT(CASE
        WHEN Station_Name LIKE '%Railway%' THEN Station_Name
    END) AS Railway_Station_Count,
    COUNT(CASE
        WHEN Station_Name LIKE '%Metro Station' THEN Station_Name
    END) AS Metro_Station_Count
FROM
    Transport
WHERE
    Transport_Type = 'Train Station'
GROUP BY Transport_Type;

 -- Query 04
SELECT 
    T.State, G.God_Name, COUNT(T.Temple_Name) AS Temple_count
FROM
    Temple T
        INNER JOIN
    God_Temple GT ON T.Temple_ID = GT.Temple_ID
        INNER JOIN
    God G ON G.God_ID = GT.God_ID
WHERE
    G.God_Name IN (SELECT DISTINCT
            G.God_Name
        FROM
            God AS G
                INNER JOIN
            God_Festival GF ON G.God_ID = GF.God_ID
                INNER JOIN
            Festival F ON F.Festival_ID = GF.Festival_ID
        WHERE
           Month( Festival_Date) >= 9 )
GROUP BY T.State , G.God_Name
ORDER BY Temple_count DESC
LIMIT 1;

--  Query 5
SELECT 
    G.God_Name,
    G.Alias,
    COUNT(S.Scripture_Name) AS No_of_Scriptures
FROM
    God G
        INNER JOIN
    God_scripture GS ON G.God_ID = GS.God_ID
        INNER JOIN
    Scriptures S ON S.Scripture_ID = GS.Scripture_ID
WHERE
    G.God_Name IN ('Lord Shiva' , 'Lord Vishnu', 'Lord Ganesha')
GROUP BY G.God_Name , G.Alias;

-- Query 6
SELECT 
    TR.Station_Name,
    T.Temple_Name,
    COUNT(G.God_Name) AS No_Gods_Worshiped
FROM
    Temple T
        INNER JOIN
    temple_transport TT ON T.Temple_ID = TT.Temple_ID
        INNER JOIN
    Transport TR ON TR.Transport_ID = TT.Transport_ID
        INNER JOIN
    God_Temple GT ON T.Temple_ID = GT.Temple_ID
        INNER JOIN
    God G ON G.God_ID = GT.God_ID
WHERE
    TR.Station_Name = 'Chandigarh Airport'  
GROUP BY TR.Station_Name , T.Temple_Name
HAVING No_Gods_Worshiped >=5
ORDER BY No_Gods_Worshiped DESC;

-- Query 7
SELECT DISTINCT
    G.God_Name,
    COUNT(DISTINCT F.Festival_Name) AS Festival_Count
FROM
    God AS G
        INNER JOIN
    God_Festival GF ON G.God_ID = GF.God_ID
        INNER JOIN
    Festival F ON F.Festival_ID = GF.Festival_ID
WHERE
    MONTH(Festival_Date) = 10
        AND DAY(Festival_Date) BETWEEN 5 AND 25
GROUP BY G.God_Name
HAVING Festival_Count >= 2
ORDER BY Festival_Count;

-- Query 8
SELECT 
    MONTH(Festival_Date) AS Month_Name,
    COUNT(DISTINCT Festival_Name) AS Festival_Count
FROM
    Festival AS F
        INNER JOIN
    God_Festival GF ON F.Festival_ID = GF.Festival_ID
        INNER JOIN
    God G ON G.God_ID = GF.God_ID
WHERE
    G.God_Name = 'Lord Krishna'
GROUP BY Month_Name
ORDER BY Festival_Count DESC
LIMIT 1;

-- Query 9
SELECT 
    COUNT(CASE
        WHEN God_Name LIKE 'Lord%' THEN God_Name
    END) AS God,
    COUNT(CASE
        WHEN God_Name LIKE 'Goddess%' THEN God_Name
    END) AS Goddess
FROM
    God;
    
    -- Query 10
SELECT 
    T.State, G.God_Name, COUNT(temple_name) AS count_temple
FROM
    Temple T
        INNER JOIN
    God_Temple GT ON T.Temple_ID = GT.Temple_ID
        INNER JOIN
    God G ON G.God_ID = GT.God_ID
WHERE
    G.God_Name = 'Lord Vishnu'
GROUP BY State , God_Name
ORDER BY count_temple DESC
LIMIT 1;
