import React, { FC, useEffect, useState } from 'react';
import { Stack, Typography, Grid, CircularProgress, Alert } from '@mui/material';

const Stats: FC = () => {
  const [stats, setStats] = useState<{ memoCount: number }>();
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const getStats = async () => {
    try {
      const res = await API.get('public', '/stats', {});
      setStats(res);
    } catch (e) {
      setError('Failed to fetch stats. Please try again later.');
      console.error('Error fetching stats:', e);
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    getStats();
  }, []);

  if (isLoading) {
    return <CircularProgress />;
  }

  if (error) {
    return <Alert severity="error">{error}</Alert>;
  }

  return (
    <>
      {stats == null ? (
        ''
      ) : (
        <Stack justifyContent="center" alignItems="center" sx={{ m: 2 }}>
          <Typography variant="h3" component="div" gutterBottom>
            Until today...
          </Typography>
          <Grid justifyContent="center" container spacing={5}>
            <Grid item>
              <Stack alignItems="center" justifyContent="center">
                <Typography variant="h2" component="div" gutterBottom>
                  {stats.memoCount}
                </Typography>
                <Typography variant="h5" component="div" gutterBottom>
                  memos written
                </Typography>
              </Stack>
            </Grid>
          </Grid>
        </Stack>
      )}
    </>
  );
};

export default Stats;