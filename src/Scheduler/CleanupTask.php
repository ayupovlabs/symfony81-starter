<?php

declare(strict_types=1);

namespace App\Scheduler;

use Symfony\Component\Scheduler\Attribute\AsCronTask;

final class CleanupTask
{
    #[AsCronTask('0 3 * * *')]
    public function __invoke(): void
    {
        // Scheduled work goes here.
    }
}
