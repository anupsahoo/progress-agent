import React from 'react';

/**
 * CogenSight mark: a circle, green over blue, with a white left-pointing
 * wedge cut in from the right edge to the centre so the disc reads as a "C".
 */
export function CogenSightMark({ size = 32 }: { size?: number }) {
  return (
    <svg width={size} height={size} viewBox="0 0 48 48" aria-hidden focusable="false">
      <path d="M2 24a22 22 0 0 1 44 0Z" fill="#3A9A2E" />
      <path d="M2 24a22 22 0 0 0 44 0Z" fill="#1F4E9E" />
      <path d="M48 9.5 25 24l23 14.5V30.6L37.6 24 48 17.4Z" fill="#fff" />
      <path d="M48 17.4 37.6 24 48 30.6Z" fill="#fff" />
    </svg>
  );
}

export function CogenSightWordmark({ size = 22 }: { size?: number }) {
  return (
    <span className="cs-word" style={{ fontSize: size }}>
      Cogen<b>Sight</b>
    </span>
  );
}

/** Logo, wordmark and tagline block used in the sidebar header. */
export function CogenSightLockup({ onClick }: { onClick?: (e: React.MouseEvent) => void }) {
  return (
    <a href="#dashboard" className="cs-card" onClick={onClick} aria-label="CogenSight, Sports2000 back office home">
      <span className="cs-logo">
        <img src={`${import.meta.env.BASE_URL}brand/cogensight-logo.png`} alt="CogenSight" style={{ height: 76, width: 'auto', display: 'block', margin: '-6px 0 -8px' }} />
      </span>
      <span className="cs-tag">Co-Creating Value</span>
    </a>
  );
}
