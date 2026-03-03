      PROGRAM MAIN
      IMPLICIT NONE
      
      INTEGER, ALLOCATABLE :: ARR(:)
      INTEGER :: N = 1000
      INTEGER :: MIN = -100, MAX = 100
      
      INTEGER :: START, FINISH
      
      ALLOCATE(ARR(N))
      CALL FILL_ARRAY(ARR, N, MIN, MAX)    
      
C     PRINT*, ARR
      
C     TEST ALGORITMU 1
      PRINT*, '------ALGORITMUS 1------'
      CALL ALGO1(ARR, N, START, FINISH)
      IF (START == 0 .AND. FINISH == 0) THEN
          PRINT*, "PODPOLE NEEXISTUJE"
      ELSE
          PRINT*, "PODPOLE NALEZENO S DELKOU: ", (FINISH - START + 2)
          PRINT*, "INDEXY PODPOLE: ", START, FINISH
          CALL PRINT_SLICE(ARR, START, FINISH)
      END IF
      
C     TEST ALGORITMU 2
      PRINT*, '------ALGORITMUS 2------'
      CALL ALGO2(ARR, N, START, FINISH)
      IF (START == 0 .AND. FINISH == 0) THEN
          PRINT*, "PODPOLE NEEXISTUJE"
      ELSE
          PRINT*, "PODPOLE NALEZENO S DELKOU: ", (FINISH - START + 2)
          PRINT*, "INDEXY PODPOLE: ", START, FINISH
          CALL PRINT_SLICE(ARR, START, FINISH)
      END IF 
      PAUSE
      
      CONTAINS
      
C
C     ALGORITMUS 1 - HRUBA SILA
C      
      SUBROUTINE ALGO1(ARR, N, START, FINISH)
          INTEGER, INTENT(IN)     :: N, ARR(N)
          INTEGER, INTENT(OUT)    :: START, FINISH
          INTEGER :: POS, NEG, SLICE_SIZE, SLICE_START
  
C     UPRAVA POCATECNI DELKY PODPOLE NA NEJBLIZSI SUDE CISLO          
      IF (MOD(N,2) == 0) THEN
          SLICE_SIZE = N
      ELSE
          SLICE_SIZE = N - 1
      END IF
      
C     PROJEDEME VSECHNY SUDE DELKY PODPOLE
      DO WHILE (SLICE_SIZE >= 2)
          SLICE_START = 1
C         PROJEDEME VSECHNY PODPOLE DELKY SLICE_SIZE         
          DO WHILE (SLICE_START + SLICE_SIZE  <= N + 1)
              CALL COUNT_SLICE_POSNEG(ARR, N, SLICE_START, 
     &        SLICE_START + SLICE_SIZE - 1, POS, NEG) 
             
C             SHODA NALEZENA              
              IF (POS == NEG) THEN
                  START = SLICE_START
                  FINISH = SLICE_START + SLICE_SIZE - 1
                  RETURN
              END IF
              
              SLICE_START = SLICE_START + 1
          END DO
          SLICE_SIZE = SLICE_SIZE - 2
      END DO 
      
C     SHODA NENALEZENA NIKDY      
      START = 0
      FINISH = 0
      END SUBROUTINE ALGO1
      
C
C     ALGORITMUS 2 - PREFIX
C     
      SUBROUTINE ALGO2(ARR, N, START, FINISH)
          INTEGER, INTENT(IN)     :: N, ARR(N)
          INTEGER, INTENT(OUT)    :: START, FINISH
          INTEGER :: I, SUM = 0
          INTEGER :: PREFIX(-N:N) 
          START = 0
          FINISH = 0
          
C         INDEX POLE = PREFIXOVÝ SOUÈET, HODNOTA V POLI = VÝSKYT (POZICE) V POLI ARR
C         HODNOTA -2 ZNAÈÍ "NIKDY JSME NEVIDÌLI"
          PREFIX = -2
          
C         SOUCET 0 NA POZICI "PRED POLEM" (INDEX 0 JE SOUCET 0, HODNOTA 0 JE INDEX V ARR)
          PREFIX(0) = 0

          DO I = 1, N
              IF (ARR(I) >= 0) THEN
                  SUM = SUM + 1
              ELSE
                  SUM = SUM - 1
              END IF
              
C             PREFIX JSME NEVIDELI - ULOZIME JEHO INDEX
              IF (PREFIX(SUM) == -2) THEN
                  PREFIX(SUM) = I
              ELSE
C             PREFIX JSME UZ VIDELI
C             KOUKNEME SE KDE A ZKONTROLUJEME, JESTLI NOVA DELKA JE LEPSI
                  IF (I - PREFIX(SUM) > FINISH - START) THEN
                      START = PREFIX(SUM) + 1
                      FINISH = I
                  END IF
              END IF
          END DO
      END SUBROUTINE ALGO2      
      
C
C     POMOCNA RUTINA PRO SPOCITANI KLADNYCH A ZAPORNYCH CISEL V PODPOLI
C
      SUBROUTINE COUNT_SLICE_POSNEG (ARR, N, START, FINISH, POS, NEG)
          INTEGER, INTENT(IN) :: N, ARR(N), START, FINISH
          INTEGER, INTENT(OUT) :: POS, NEG
          INTEGER :: I
          
          POS = 0
          NEG = 0
          
          DO I = START, FINISH
              IF (ARR(I) >= 0) THEN
                  POS = POS + 1
              ELSE
                  NEG = NEG + 1
              END IF
          END DO   
      END SUBROUTINE COUNT_SLICE_POSNEG
      
C
C     POMOCNA RUTINA PRO NAPLNENI POLE NAHODNYMI CISLY
C
      SUBROUTINE FILL_ARRAY(ARR, N, MIN, MAX)
          INTEGER, INTENT(IN)     :: N, MIN, MAX
          INTEGER, INTENT(OUT)    :: ARR(N)
          INTEGER                 :: I
          DOUBLE PRECISION        :: R
          
          CALL RANDOM_SEED()
          
          DO I = 1, N
              CALL RANDOM_NUMBER(R)
              ARR(I) = MIN + INT(R * (MAX - MIN + 1))
          END DO
      END SUBROUTINE FILL_ARRAY
      
C
C     POMOCNA RUTINA PRO VYPIS USEKU POLE
C
      SUBROUTINE PRINT_SLICE(ARR, START, FINISH)
          INTEGER, INTENT(IN) :: START, FINISH
          INTEGER, INTENT(IN) :: ARR(:)
          
          PRINT '(*(I0,1X))', ARR(START:FINISH)
      END SUBROUTINE PRINT_SLICE
          
      END PROGRAM MAIN